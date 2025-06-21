class LoginRequest {
  final String? username;
  final String? password;
  final String deviceId;

  LoginRequest({this.username, this.password, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'device_id': deviceId};
  }
}
