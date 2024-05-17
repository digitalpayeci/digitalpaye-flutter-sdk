import 'package:equatable/equatable.dart';

enum NetworkMethod { get, post, put, delete }

class NetWorkRequest extends Equatable {
  final String path;
  final Map<String, String> headers;
  final NetworkMethod method;
  final Map<String, dynamic>? body;

  const NetWorkRequest({
    required this.path,
    this.body,
    required this.method,
    this.headers = const {"Content-Type": 'application/json'},
  });

  @override
  List<Object> get props => [path];
}
