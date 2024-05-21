// lib/models/digitalpaye_payment_config.dart
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_countries.dart';
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_currencies.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_payment_config_interface.dart';

class DigitalpayePaymentConfig implements DigitalpayePaymentConfigInterface {
  @override
  final DigitalpayeEnumCountries codeCountry;
  @override
  final double amount;
  @override
  final String transactionId;
  @override
  final String designation;
  @override
  final String? customerId;
  @override
  final String? nameUser;
  @override
  final String? emailUser;
  @override
  final DigitalpayeEnumCurrencies currency;
  @override
  final String? urlSuccess;
  @override
  final String? urlError;

  DigitalpayePaymentConfig({
    required this.codeCountry,
    required this.amount,
    required this.transactionId,
    required this.designation,
    this.customerId,
    this.nameUser,
    this.emailUser,
    required this.currency,
    this.urlError,
    this.urlSuccess,
  });
}
