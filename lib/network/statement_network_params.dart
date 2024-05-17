class StatementNetworkParams {
  final String siteId;
  final int limit;
  final int dataType;
  final String? fromDate;

  String get queryPath {
    return "?dataType=$dataType&siteId=$siteId";
  }

  StatementNetworkParams(
      {required this.siteId,
      this.limit = 1000,
      this.dataType = 1,
      this.fromDate});
}
