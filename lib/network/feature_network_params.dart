import 'feature_network_params_type.dart';

class FeatureNetworkParams {
  final String siteId;
  final FeatureNetworkParamsType paramsType;
  final int limit;
  final int dataType;
  final String statementId;
  final String? fromDate;
  final int status;

  String get queryPath =>
      "?status=$status&siteId=$siteId&dataType=$dataType&${paramsType.statementName}=$statementId";

  FeatureNetworkParams({
    required this.siteId,
    required this.statementId,
    required this.paramsType,
    this.limit = 1000,
    this.dataType = 1,
    this.fromDate,
    this.status = 0,
  });
}
