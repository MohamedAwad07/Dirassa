import 'package:equatable/equatable.dart';

class ConfigResponse extends Equatable {
  final String? registerUrl;
  final String? homeUrl;
  final String? profileUrl;

  const ConfigResponse({
    required this.registerUrl,
    required this.homeUrl,
    required this.profileUrl,
  });

  factory ConfigResponse.fromJson(Map<String, dynamic> json) {
    return ConfigResponse(
      homeUrl: json['home_url'] as String?,
      profileUrl: json['profile_url'] as String?,
      registerUrl: json['register_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [registerUrl, homeUrl, profileUrl];

  ConfigResponse copyWith({
    String? registerUrl,
    String? homeUrl,
    String? profileUrl,
  }) {
    return ConfigResponse(
      registerUrl: registerUrl ?? this.registerUrl,
      homeUrl: homeUrl ?? this.homeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}
