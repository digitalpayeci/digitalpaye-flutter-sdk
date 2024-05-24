class DefaultNetworkResponse<T> {
  int codeStatus;
  String status;
  String? message;
  T? data;

  DefaultNetworkResponse({
    required this.codeStatus,
    required this.status,
    this.message,
    this.data,
  });

  factory DefaultNetworkResponse.fromJson(
    Map<String, dynamic> json,
    Function(dynamic)? fromJson,
  ) {
    return DefaultNetworkResponse<T>(
      codeStatus: json["code_status"],
      status: json["status"],
      message: json["message"],
      data: json['data'] == null ? null : fromJson?.call(json['data']),
    );
  }
}
