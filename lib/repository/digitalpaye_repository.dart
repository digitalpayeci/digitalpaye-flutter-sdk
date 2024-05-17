// lib/repository/repository.dart
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_repository_interface.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_process.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_token.dart';
import 'package:digitalpaye_sdk_flutter/network/network_error.dart';
import 'package:digitalpaye_sdk_flutter/network/response/base_network_response.dart';
import 'package:digitalpaye_sdk_flutter/utils/constantes.dart';
import 'package:http/http.dart' as http;

class DigitalpayeRepository extends DigitalpayeRepositoryInterface {
  final DigitalpayeConfigInterface config;

  DigitalpayeRepository(this.config);

  @override
  Future<
      Either<NetworkError,
          DefaultNetworkResponse<DigitalpayeResponsePayment>>> createPayment(
      {required DigitalpayePaymentProcess payment,
      required String token}) async {
    try {
      final url = config.isSandbox
          ? Constantes.apiUrlSandbox
          : '${Constantes.apiUrlProd}/${Constantes.versionApp}/collecte/mobile-money';
      final response = await http.post(Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "code_country": payment.codeCountry,
            "operator": payment.operator,
            "currency": payment.currency,
            "url_success": payment.urlSuccess ?? "",
            "url_error": payment.urlError ?? "",
            "customer_id": payment.customerId,
            "amount": payment.amount,
            "name_user": payment.nameUser ?? "",
            "email": payment.emailUser ?? "",
            "transaction_id": payment.transactionId,
            "code_otp": payment.otpCode,
          }));
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final data = jsonDecode(response.body);
        return Right(
          DefaultNetworkResponse(
            codeStatus: data["code_status"],
            status: data["status"],
            data: DigitalpayeResponsePayment.fromJson(data["data"]),
          ),
        );
      } else if (response.statusCode == 504) {
        final data = jsonDecode(response.body);
        return Left(
          NetworkError(
            codeStatus: data["code_status"],
            status: data["status"],
            message: data["message"],
            data: DigitalpayeResponsePayment.fromJson(data["data"]),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        return Left(NetworkError(
            codeStatus: data["code_status"],
            status: data["status"],
            message: data["message"]));
      }
    } catch (e) {
      // Gérer les erreurs
      return Left(NetworkError(message: e.toString()));
    }
  }

  @override
  Future<
          Either<NetworkError,
              DefaultNetworkResponse<DigitalpayeResponsePayment>>>
      checkStatusTransaction(
          {required String transactionId, required String token}) async {
    try {
      final url = config.isSandbox
          ? Constantes.apiUrlSandbox
          : '${Constantes.apiUrlProd}/${Constantes.versionApp}/get-status-payment/$transactionId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final data = jsonDecode(response.body);
        return Right(
          DefaultNetworkResponse(
            codeStatus: data["code_status"],
            status: data["status"],
            data: DigitalpayeResponsePayment.fromJson(data["data"]),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        return Left(NetworkError(
            codeStatus: data["code_status"],
            status: data["status"],
            message: data["message"]));
      }
    } catch (e) {
      // Gérer les erreurs
      return Left(NetworkError(message: e.toString()));
    }
  }

  @override
  Future<Either<NetworkError, DigitalpayeResponseToken>> generateToken() async {
    try {
      final url = config.isSandbox
          ? Constantes.apiUrlSandbox
          : '${Constantes.apiUrlProd}/${Constantes.versionApp}/auth';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('${config.apiKey}:${config.apiSecret}'))}';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(
          DigitalpayeResponseToken(
            codeStatus: data["code_status"],
            status: data["status"],
            token: data["token"],
            exp: data["exp"],
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        return Left(
          NetworkError(
            codeStatus: data["code_status"],
            status: data["status"],
            message: data["message"],
          ),
        );
      }
    } catch (e) {
      // Gérer les erreurs
      return Left(NetworkError(message: e.toString()));
    }
  }
}
