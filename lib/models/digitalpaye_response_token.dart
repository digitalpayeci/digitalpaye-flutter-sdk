import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_response_token_interface.dart';

class DigitalpayeResponseToken implements DigitalpayeResponseTokenInterface {
  @override
  final int codeStatus;
  @override
  final String status;
  @override
  final String? message;
  @override
  final String? token;
  @override
  final int? exp;

  DigitalpayeResponseToken({
    required this.codeStatus,
    required this.status,
    this.message,
    this.token,
    this.exp,
  });

  factory DigitalpayeResponseToken.fromJson(Map<String, dynamic> json) {
    return DigitalpayeResponseToken(
      codeStatus: json['code_status'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      token: json['token'] as String,
      exp: json['exp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code_status': codeStatus,
      'status': status,
      'message': message,
      'token': token,
      'exp': exp,
    };
  }
}
