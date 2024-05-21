import 'dart:convert';
import 'package:digitalpaye_sdk_flutter/logger/digitalpaye_logger.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'network_error.dart';
import 'network_error_type.dart';
import 'network_param.dart';

abstract class NetworkService<NetWorkParam> {
  Future<Either<NetworkError, dynamic>> fetchRequest(NetWorkRequest request);
}

class NetworkServiceImpl extends NetworkService<NetWorkRequest> {
  NetworkServiceImpl({
    required this.httpClient,
  });

  final Client httpClient;

  @override
  Future<Either<NetworkError, Map<String, dynamic>>> fetchRequest(
    NetWorkRequest request,
  ) async {
    try {
      switch (request.method) {
        case NetworkMethod.get:
          {
            return await _getRequest(request);
          }
        case NetworkMethod.post:
          {
            DigitalpayeLogger.d(
                "==================== request data ====================");
            DigitalpayeLogger.d("Path:", request.path);
            DigitalpayeLogger.d("Body:", request.body);
            return await _postRequest(request);
          }
        case NetworkMethod.put:
          return await _putRequest(request);
        case NetworkMethod.delete:
          return await _deleteRequest(request);
      }
    } on Error catch (error) {
      DigitalpayeLogger.e("NetworkServiceImpl - An error occured :", error);
      throw UnimplementedError(error.toString());
    }
  }

  String _baseUrlFrom({required NetWorkRequest request}) {
    return request.path;
  }

  Future<Either<NetworkError, Map<String, dynamic>>> _getRequest(
    NetWorkRequest request,
  ) async {
    final url = Uri.parse(_baseUrlFrom(request: request));
    final response = await http.get(
      url,
      headers: await _headersFrom(),
    );
    return _response(response);
  }

  Future<Either<NetworkError, Map<String, dynamic>>> _postRequest(
    NetWorkRequest request,
  ) async {
    final url = Uri.parse(_baseUrlFrom(request: request));
    final response = await http.post(
      url,
      body: request.body,
      headers: await _headersFrom(),
    );
    return _response(response);
  }

  Future<Either<NetworkError, Map<String, dynamic>>> _putRequest(
      NetWorkRequest request) async {
    final url = Uri.parse(_baseUrlFrom(request: request));
    final response = await http.put(
      url,
      body: json.encode(request.body),
      headers: await _headersFrom(),
    );
    return _response(response);
  }

  Future<Either<NetworkError, Map<String, dynamic>>> _deleteRequest(
      NetWorkRequest request) async {
    final url = Uri.parse(_baseUrlFrom(request: request));
    final body = request.body == null ? null : json.encode(request.body);
    final response = await http.delete(
      url,
      body: body,
      headers: await _headersFrom(),
    );
    return _response(response);
  }

  Future<Map<String, String>> _headersFrom() async {
    Map<String, String> headers = {};
    headers.addEntries(headers.entries);
    return headers;
  }

  NetworkError _noInternetError() {
    return NetworkError(
        message: "No internet Connection",
        type: NetworkErrorType.NoInternetConnection);
  }

  Either<NetworkError, Map<String, dynamic>> _response(http.Response response) {
    DigitalpayeLogger.d(
        "==================== request response ====================");
    DigitalpayeLogger.d("Endpoint:", response.request?.url);
    DigitalpayeLogger.d("StatusCode:", response.statusCode);
    DigitalpayeLogger.d("Body:", response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 206:
        return Right(jsonDecode(response.body.toString()));
      default:
        return Left(_errorFrom(response));
    }
  }

  NetworkError _errorFrom(http.Response response) {
    Map<String, dynamic> jsonResult = jsonDecode(response.body.toString());
    jsonResult['statusCode'] = jsonResult['statusCode'] == null
        ? jsonResult['statusCode']
        : response.statusCode;

    return NetworkError.fromJson(json: jsonResult);
  }
}
