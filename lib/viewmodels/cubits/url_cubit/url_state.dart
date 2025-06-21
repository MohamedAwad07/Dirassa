part of 'url_cubit.dart';

enum UrlStatus { initial, loading, success, error }

class UrlState extends Equatable {
  final UrlStatus status;
  final String? homeUrl;
  final String? profileUrl;
  final String? registerUrl;
  final String? errorMessage;

  const UrlState({
    this.status = UrlStatus.initial,
    this.homeUrl,
    this.profileUrl,
    this.registerUrl,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    homeUrl,
    profileUrl,
    registerUrl,
    errorMessage,
  ];

  UrlState copyWith({
    UrlStatus? status,
    String? homeUrl,
    String? profileUrl,
    String? registerUrl,
    String? errorMessage,
  }) {
    return UrlState(
      status: status ?? this.status,
      homeUrl: homeUrl ?? this.homeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
      registerUrl: registerUrl ?? this.registerUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
