import 'jsonable.dart';

class BaseNetworkResponse<T extends Jsonable> {
  bool success;
  String message;
  List<T> result;

  BaseNetworkResponse(
      {required this.success, required this.message, required this.result});

  factory BaseNetworkResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) fromJson) {
    List<T> _records = [];
    if (json['result'] != null) {
      json['result'].forEach((v) {
        _records.add(fromJson(v));
      });
    }

    return BaseNetworkResponse<T>(
      success: json["success"],
      message: json["message"],
      result: _records,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": this.success,
        "message": this.message,
        "result": this.result.map((v) => v.toJson()).toList(),
      };
}

// TODO: This must replace `BaseNetworkResponse`
class DefaultNetworkResponse<T> {
  int codeStatus;
  String status;
  String? message;
  T? data;

  DefaultNetworkResponse(
      {required this.codeStatus,
      required this.status,
      this.message,
      this.data});

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
