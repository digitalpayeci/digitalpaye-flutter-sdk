import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_countries.dart';
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_currencies.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_payment_process_interface.dart';

class DigitalpayePaymentProcess implements DigitalpayePaymentProcessInterface {
  @override
  final DigitalpayeEnumCountries codeCountry;

  @override
  final double amount;

  @override
  final String transactionId;

  @override
  final String? customerId;

  @override
  final String? nameUser;

  @override
  final String? emailUser;
  @override
  final String designation;

  @override
  final DigitalpayeEnumCurrencies currency;

  @override
  final String operator;

  @override
  final String? urlSuccess;

  @override
  final String? otpCode;

  @override
  final String? urlError;

  DigitalpayePaymentProcess({
    required this.codeCountry,
    required this.amount,
    required this.transactionId,
    required this.designation,
    this.customerId,
    this.nameUser,
    this.emailUser,
    required this.currency,
    required this.operator,
    this.otpCode,
    this.urlError,
    this.urlSuccess,
  });
}
