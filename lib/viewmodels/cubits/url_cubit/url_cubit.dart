import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dirassa/core/functions/api_handler.dart';

part 'url_state.dart';

class UrlCubit extends Cubit<UrlState> {
  UrlCubit() : super(const UrlState());

  Future<void> fetchUrls() async {
    emit(state.copyWith(status: UrlStatus.loading));

    try {
      final config = await fetchConfig();
      emit(
        state.copyWith(
          status: UrlStatus.success,
          homeUrl: config.homeUrl,
          profileUrl: config.profileUrl,
          registerUrl: config.registerUrl,
          loginUrl: config.loginUrl,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: UrlStatus.error, errorMessage: e.toString()));
    }
  }

  void reset() {
    emit(const UrlState());
  }
}
