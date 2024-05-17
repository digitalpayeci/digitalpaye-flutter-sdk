abstract class DigitalpayeResponseTokenInterface {
  int get codeStatus;
  String get status;
  String? get message;
  String? get token;
  int? get exp;
}
