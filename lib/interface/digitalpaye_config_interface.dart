// lib/interface/digitalpaye_config_interface.dart
import 'package:flutter/material.dart';

abstract class DigitalpayeConfigInterface {
  String get apiKey;
  String get apiSecret;
  String? get logo;
  Color? get color;
  bool get isSandbox;
}