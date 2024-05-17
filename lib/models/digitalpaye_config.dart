import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:flutter/material.dart';

class DigitalpayeConfig extends DigitalpayeConfigInterface {
  @override
  final String apiKey;
  @override
  final String apiSecret;
  @override
  final String? logo;
  @override
  final Color color;
  @override
  final bool isSandbox;

  DigitalpayeConfig({
    required this.apiKey,
    required this.apiSecret,
    this.logo,
    Color? color,
    this.isSandbox = true,
  }) : color = color ?? AppColors.primaryColor;

  String getApiKey() => apiKey;

  String getApiSecret() => apiSecret;

  String? getLogo() => logo;

  Color getColor() => color;

  bool getIsSandbox() => isSandbox;
}
