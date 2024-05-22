import 'dart:math';
import 'package:digitalpaye_sdk_flutter/digitalpaye_sdk_flutter.dart';
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_countries.dart';
import 'package:digitalpaye_sdk_flutter/enum/digitalpaye_enum_currencies.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_config.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_config.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

String generatePaymentId({int length = 20}) {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = DigitalpayeConfig(
      apiKey: 'live_digitalpaye933061',
      apiSecret: 'f511e4f4-d932-4fcd-a804-51539700d60c',
      isSandbox: false,
      color: AppColors.orange,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Digitalpaye Flutter SDK Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final paymentId = generatePaymentId();
            final payment = DigitalpayePaymentConfig(
              codeCountry: DigitalpayeEnumCountries.ivoryCoast,
              amount: 10000.0,
              transactionId: paymentId,
              designation: "Vente de télévision",
              currency: DigitalpayeEnumCurrencies.xof,
              emailUser: "elieguei225@gmail.com",
              nameUser: "HELIE GUEI",
              customerId: "0777101308",
              urlError: "https://digitalpaye.com",
              urlSuccess: "https://digitalpaye.com",
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DigitalpayeFlutterSDK(
                  config: config,
                  payment: payment,
                  errorBuilder: (error) {
                    return Container();
                  },
                  successBuilder: (success) {
                    return Container();
                  },
                  pendingBuilder: (pending) {
                   return Container();
                  },
                ),
              ),
            );
          },
          child: const Text('Make Payment'),
        ),
      ),
    );
  }
}
