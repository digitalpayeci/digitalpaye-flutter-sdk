import 'package:dartz/dartz.dart';
import 'package:digitalpaye_sdk_flutter/network/feature_network_params.dart';
import 'package:digitalpaye_sdk_flutter/network/network_error.dart';
import 'package:digitalpaye_sdk_flutter/network/network_param.dart';
import 'package:digitalpaye_sdk_flutter/network/network_service.dart';
import 'package:digitalpaye_sdk_flutter/network/response/base_network_response.dart';
import 'package:digitalpaye_sdk_flutter/network/response/digitalpaye_result.dart';
import 'package:digitalpaye_sdk_flutter/network/response/jsonable.dart';

abstract class BaseRepository<T extends Jsonable> {
  Future<DigitalpayeResult<NetworkError, BaseNetworkResponse<T>>> fetchRecords(
      String path,
      FeatureNetworkParams params,
      String? sufixQuerry,
      Function(Map<String, dynamic>) fromJson);
}

class BaseRepositoryRepositoryImpl<T extends Jsonable>
    implements BaseRepository<T> {
  final NetworkService networkService;

  BaseRepositoryRepositoryImpl({required this.networkService});

  @override
  Future<DigitalpayeResult<NetworkError, BaseNetworkResponse<T>>> fetchRecords(
      String path,
      FeatureNetworkParams params,
      String? sufixQuerry,
      Function(Map<String, dynamic>) fromJson) async {
    NetWorkRequest request = NetWorkRequest(
        path:
            path + params.queryPath + (sufixQuerry ?? ""),
        method: NetworkMethod.get);

    final result = await networkService.fetchRequest(request);
    return result.fold((error) => Left(error), (json) async {
      try {
        BaseNetworkResponse<T> response =
            BaseNetworkResponse.fromJson(json, fromJson);
        return Right(response);
      } catch (error) {
        return Left(NetworkError(message: "Error durant le parsing"));
      }
    });
  }
}
