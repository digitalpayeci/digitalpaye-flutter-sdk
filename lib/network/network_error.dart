import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';

import 'network_error_type.dart';

abstract class HGError extends Error {
  String localizableMessage();
}

class NetworkError extends HGError {
  final int? codeStatus;
  final String? status;
  final String message;
  final NetworkErrorType? type;
  final DigitalpayeResponsePayment? data;

  NetworkError({
    this.codeStatus,
    this.status,
    required this.message,
    this.type,
    this.data,
  });

  factory NetworkError.fromJson({required Map<String, dynamic> json}) {
    return NetworkError(
      message: json['message'],
      codeStatus: json['code_status']?.toInt(),
      status: json['status']?.toString(),
      type: NetworkErrorType.fromCode(json['statusCode']?.toInt() ?? 0),
      data: json['data'] != null ? DigitalpayeResponsePayment.fromJson(json['data']) : null,
    );
  }

  @override
  String toString() {
    return "NetworkError - statusCode: $codeStatus - message: $message";
  }

  @override
  String localizableMessage() {
    switch (type) {
      case NetworkErrorType.NotFoundException:
        return "";
      case NetworkErrorType.Forbidden:
        return "";
      case NetworkErrorType.BadRequestException:
        return "BAD_REQUEST_EXCEPTION";
      case NetworkErrorType.NoInternetConnection:
        return "";
      default:
        return message;
    }
  }
}
