import 'package:dartz/dartz.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_process.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_token.dart';
import 'package:digitalpaye_sdk_flutter/network/network_error.dart';
import 'package:digitalpaye_sdk_flutter/network/response/default_network_response.dart';

abstract class DigitalpayeRepositoryInterface {
  Future<
      Either<NetworkError,
          DefaultNetworkResponse<DigitalpayeResponsePayment>>> createPayment(
      {required DigitalpayePaymentProcess payment, required String token});
  Future<
      Either<NetworkError,
         DigitalpayeResponseToken>> generateToken();
  Future<
          Either<NetworkError,
              DefaultNetworkResponse<DigitalpayeResponsePayment>>>
      checkStatusTransaction(
          {required String transactionId, required String token});
}
