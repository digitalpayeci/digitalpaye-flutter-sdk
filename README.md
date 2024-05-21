# Digitalpaye Flutter SDK

## Description du SDK

Le SDK Flutter Digitalpaye permet aux développeurs d'intégrer facilement les paiements via Digitalpaye dans leurs applications Flutter. Il fournit une interface simple pour configurer et initier des transactions de paiement.

## Installation

Pour installer le SDK, utilisez la commande suivante :

```sh
flutter pub add digitalpaye_sdk_flutter
```

## Démarrage

### Configuration

Avant d'utiliser le SDK, configurez-le avec vos informations d'API. Vous devez fournir une clé API, un secret API, et d'autres paramètres de configuration.

```dart
final config = DigitalpayeConfig(
  apiKey: 'live_digitalpaye931',
  apiSecret: 'f511e4f4-d932-928cd-a804-51539700d60c',
  isSandbox: false,
  color: AppColors.orange,
);

// Constructeur de DigitalpayeConfig
DigitalpayeConfig({required String apiKey, required String apiSecret, required bool isSandbox, Color ? color, String ?logo});
```

- apiKey : Votre clé API
- apiSecret : Votre secret API
- isSandbox : Booléen pour indiquer si l'environnement est en mode sandbox
- color : Couleur principale de l'application
- logo : Le logo de l'application


### Configuration de paiement

Définissez les paramètres de votre transaction de paiement.

```dart
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
```

- codeCountry : Code du pays
- amount : Montant de la transaction
- transactionId : ID de la transaction
- designation : Description de la transaction
- currency : Devise de la transaction
- emailUser : Email de l'utilisateur
- nameUser : Nom de l'utilisateur
- customerId : ID du client
- urlError : URL en cas d'erreur
- urlSuccess : URL en cas de succès


## Exemple d'utilisation

Voici un exemple complet de l'utilisation du SDK dans une application Flutter.

```dart
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
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

String generatePaymentId({int length = 20}) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final config = DigitalpayeConfig(
      apiKey: 'live_digitalpaye931',
      apiSecret: 'f511e4f4-d932-928cd-a804-51539700d60c',
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
              amount: 1000.0,
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
```

