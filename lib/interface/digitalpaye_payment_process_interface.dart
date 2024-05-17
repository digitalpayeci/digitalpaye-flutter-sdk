// lib/interface/digitalpaye_payment_process_interface.dart

import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_payment_config_interface.dart';

abstract class DigitalpayePaymentProcessInterface implements DigitalpayePaymentConfigInterface {
  String get operator;
  String ?get otpCode;
}
