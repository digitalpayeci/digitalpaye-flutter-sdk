class NetworkDeleteParams {
  final List<String> ids;

  NetworkDeleteParams({required this.ids});

  Map<String, dynamic> toJson() {
    return {
      "params": {"data": ids}
    };
  }
}
