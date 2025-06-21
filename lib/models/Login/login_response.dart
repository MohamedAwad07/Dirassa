class LoginResponse {
  final bool? success;
  final String? message;
  final String? token;

  LoginResponse({this.success, this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      token: json['user_token'],
    );
  }
}
