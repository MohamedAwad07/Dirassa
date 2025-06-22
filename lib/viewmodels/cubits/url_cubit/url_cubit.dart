import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dirassa/core/functions/api_handler.dart';
import 'package:dirassa/models/config_response.dart';

part 'url_state.dart';

class UrlCubit extends Cubit<UrlState> {
  UrlCubit() : super(const UrlState());

  Future<void> fetchUrls() async {
    emit(state.copyWith(status: UrlStatus.loading));

    try {
      final ApiResponse<ConfigResponse> apiResponse = await fetchConfig();

      if (apiResponse.success && apiResponse.data != null) {
        final config = apiResponse.data!;
        emit(
          state.copyWith(
            status: UrlStatus.success,
            homeUrl: config.homeUrl,
            profileUrl: config.profileUrl,
            registerUrl: config.registerUrl,
            loginUrl: config.loginUrl,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: UrlStatus.error,
            errorMessage: apiResponse.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UrlStatus.error,
          errorMessage: AppStrings.apiUnknownError,
        ),
      );
    }
  }

  void reset() {
    emit(const UrlState());
  }
}
