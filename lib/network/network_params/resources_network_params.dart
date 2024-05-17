/*class ResourcesNetworkParams {
  final String siteId;
  final String companyId;
  final int limit;
  final int dataType;

  String get queryPath {
    return "?dataType=$dataType&limit=$limit&siteId=$siteId";
  }

  ResourcesNetworkParams(
      {required this.siteId,
      required this.companyId,
      required this.limit,
      this.dataType = 1});
}*/

/*class ResourcesNetworkParams {
  final String siteId;
  final bool fetchDataInScope;
  final int limit;
  final String? lastRecordId;
  final int? dataType;

  String get queryPath {
    return "?dataType=$dataType&limit=$limit&siteId=$siteId&fetchDataInScope=$fetchDataInScope";
  }

  ResourcesNetworkParams({
    required this.siteId,
    required this.limit,
    required this.fetchDataInScope,
    this.dataType = 1,
    this.lastRecordId,
  });
}*/

class ResourcesNetworkParams {
  final List<String> siteIds;
  final bool fetchDataInScope;
  final int limit;
  final int? dataType;
  final String? companyId;

  String get queryPath {
    if (companyId != null) {
      return "?dataType=$dataType&companyId=$companyId";
    }
    // TODO: review this part, we cannot fetch data in scope and set sites (it's one or other)
    String _siteIds = "";
    siteIds.forEach((siteId) {
      _siteIds += "&siteId=$siteId";
    });
    return "?dataType=$dataType&limit=$limit&fetchDataInScope=$fetchDataInScope$_siteIds";
  }

  ResourcesNetworkParams({
    this.siteIds = const [],
    this.limit = 1000,
    this.fetchDataInScope = false,
    this.dataType = 1,
    this.companyId,
  });
}
