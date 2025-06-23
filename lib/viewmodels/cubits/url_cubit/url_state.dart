part of 'url_cubit.dart';

enum UrlStatus { initial, loading, success, error }

class UrlState extends Equatable {
  final UrlStatus status;
  final String? homeUrl;
  final String? profileUrl;
  final String? registerUrl;
  final String? loginUrl;
  final String? userAgent;
  final String? errorMessage;

  const UrlState({
    this.status = UrlStatus.initial,
    this.homeUrl,
    this.profileUrl,
    this.registerUrl,
    this.loginUrl,
    this.userAgent,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    homeUrl,
    profileUrl,
    registerUrl,
    loginUrl,
    userAgent,
    errorMessage,
  ];

  UrlState copyWith({
    UrlStatus? status,
    String? homeUrl,
    String? profileUrl,
    String? registerUrl,
    String? loginUrl,
    String? userAgent,
    String? errorMessage,
  }) {
    return UrlState(
      status: status ?? this.status,
      homeUrl: homeUrl ?? this.homeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
      registerUrl: registerUrl ?? this.registerUrl,
      loginUrl: loginUrl ?? this.loginUrl,
      userAgent: userAgent ?? this.userAgent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
