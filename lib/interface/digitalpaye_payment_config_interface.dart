// lib/interface/digitalpaye_payment_config.dart
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_countries.dart';
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_currencies.dart';

abstract class DigitalpayePaymentConfigInterface {
  DigitalpayeEnumCountries get codeCountry;
  double get amount;
  String get transactionId;
  String get designation;
  String? get customerId;
  String? get nameUser;
  String? get emailUser;
  DigitalpayeEnumCurrencies get currency;
  String? get urlSuccess;
  String? get urlError;
}
