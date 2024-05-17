// lib/interface/digitalpaye_payment_config.dart
abstract class DigitalpayePaymentConfigInterface {
  String get codeCountry;
  double get amount;
  String get transactionId;
  String get designation;
  String? get customerId;
  String? get nameUser;
  String? get emailUser;
  String get currency;
  String? get urlSuccess;
  String? get urlError;
}
