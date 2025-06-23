import 'package:equatable/equatable.dart';

class ConfigResponse extends Equatable {
  final String? loginUrl;
  final String? registerUrl;
  final String? homeUrl;
  final String? profileUrl;
  final String? userAgent;

  const ConfigResponse({
    required this.loginUrl,
    required this.registerUrl,
    required this.homeUrl,
    required this.profileUrl,
    required this.userAgent,
  });

  factory ConfigResponse.fromJson(Map<String, dynamic> json) {
    return ConfigResponse(
      loginUrl: json['login_url'] as String?,
      homeUrl: json['home_url'] as String?,
      profileUrl: json['profile_url'] as String?,
      registerUrl: json['register_url'] as String?,
      userAgent: json['user_agent'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    loginUrl,
    registerUrl,
    homeUrl,
    profileUrl,
    userAgent,
  ];

  ConfigResponse copyWith({
    String? loginUrl,
    String? registerUrl,
    String? homeUrl,
    String? profileUrl,
    String? userAgent,
  }) {
    return ConfigResponse(
      loginUrl: loginUrl ?? this.loginUrl,
      registerUrl: registerUrl ?? this.registerUrl,
      homeUrl: homeUrl ?? this.homeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
      userAgent: userAgent ?? this.userAgent,
    );
  }
}
