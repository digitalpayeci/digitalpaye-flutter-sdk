import 'dart:async';

import 'package:digitalpaye_sdk_flutter/enum/enum_status_payment.dart';
import 'package:digitalpaye_sdk_flutter/enum/enum_type_payment.dart';
import 'package:digitalpaye_sdk_flutter/logger/digitalpaye_logger.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_config.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_process.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/repository/digitalpaye_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentViewModel extends ChangeNotifier {
  // Public Properties
  bool isLoadingData = true;
  bool _isLoader = false;
  bool _showError = false;
  String? _messageError;
  ValueChanged<DigitalpayeResponsePayment>? onCallBack;
  ValueChanged<bool>? onPending;
  ValueChanged<DigitalpayeResponsePayment>? onFailed;
  ValueChanged<DigitalpayeResponsePayment>? onSuccessful;
  ValueChanged<String>? getAccessToken;

  ValueChanged<bool>? onError;
  DigitalpayeResponsePayment? responsePayment;
  String? _interfacePayment;
  String? _name;
  String? _email;
  String? _phone;
  EnumStatusPayment? _statusPayment;
  String? _codePin;
  int _totalMilliseconds = 0;
  String? _accessToken;

  DigitalpayeRepository repository;

  PaymentViewModel({required this.repository});

  List<EnumTypePayment> paymentTypes = [
    EnumTypePayment.wave,
    EnumTypePayment.mtn,
    EnumTypePayment.orange,
  ];
  EnumTypePayment? _selectedPayment;

  String? get accessToken => _accessToken;
  set accessToken(String? value) {
    _accessToken = value;
    notifyListeners();
  }

  List<EnumTypePayment> get paymentOptions => EnumTypePayment.values.toList();

  EnumTypePayment? get selectedPayment => _selectedPayment;

  void selectPayment(EnumTypePayment payment) {
    if (_selectedPayment != payment) {
      _selectedPayment = payment;
      notifyListeners();
    }
  }

  bool get isLoader => _isLoader;
  set isLoader(bool value) {
    _isLoader = value;
    notifyListeners();
  }

  EnumStatusPayment? get statusPayment => _statusPayment;
  set statusPayment(EnumStatusPayment? value) {
    _statusPayment = value;
    notifyListeners();
  }

  String? get messageError => _messageError;
  set messageError(String? value) {
    _messageError = value;
    notifyListeners();
  }

  int get totalMilliseconds => _totalMilliseconds;
  set totalMilliseconds(int value) {
    _totalMilliseconds = value;
    notifyListeners();
  }

  String? get codePin => _codePin;
  set codePin(String? value) {
    _codePin = value;
    notifyListeners();
  }

  String? get name => _name;
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  String? get email => _email;
  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  String? get interfacePayment => _interfacePayment;
  set interfacePayment(String? value) {
    _interfacePayment = value;
    notifyListeners();
  }

  String? get phone => _phone;
  set phone(String? value) {
    _phone = value;
    notifyListeners();
  }

  bool get showError => _showError;
  set showError(bool value) {
    _showError = value;
    notifyListeners();
  }

  bool get _isEmailValid =>
      _email != null &&
      _email!.isNotEmpty &&
      EmailValidator.validate(email ?? "");

  bool get _isPhoneValid =>
      _phone != null && _phone!.isNotEmpty && _phone!.length == 10;

  bool get _isPhoneValidForOperator {
    if (selectedPayment?.value == EnumTypePayment.orange.value) {
      return _phone != null && _phone!.startsWith('07');
    } else if (selectedPayment?.value == EnumTypePayment.mtn.value) {
      return _phone != null && _phone!.startsWith('05');
    } else {
      return true;
    }
  }

  bool get isButtonDisabled =>
      _selectedPayment == null ||
      _name == null ||
      _email == null ||
      !_isEmailValid ||
      _phone == null ||
      !_isPhoneValid ||
      !_isPhoneValidForOperator;

  bool get buttomOrangeMoneyisEnabled =>
      (codePin?.isNotEmpty == true && codePin?.length == 4);

  Future<void> createPayment(
      {required DigitalpayePaymentConfig params, required String token}) async {
    if (token.isNotEmpty == true) {
      _isLoader = true;
      notifyListeners();
      DigitalpayePaymentProcess payment = DigitalpayePaymentProcess(
        codeCountry: "CI",
        amount: params.amount,
        transactionId: params.transactionId,
        designation: params.designation,
        nameUser: params.nameUser ?? name,
        customerId: params.customerId ?? phone,
        currency: params.currency,
        urlError: params.urlError ?? "",
        urlSuccess: params.urlSuccess ?? "",
        emailUser: params.emailUser ?? email,
        otpCode: codePin ?? "",
        operator: selectedPayment?.value ?? "",
      );
      final result =
          await repository.createPayment(token: token, payment: payment);
      result.fold((error) {
        _isLoader = false;
        if (error.codeStatus == 504) {
          _statusPayment = EnumStatusPayment.failed;
          responsePayment = error.data;
          onCallBack?.call(error.data!);
          onFailed?.call(responsePayment!);
        } else {
          _messageError = error.message;
          _showError = true;
          onError?.call(true);
        }
      }, (response) {
        responsePayment = response.data;
        if (response.codeStatus == 202) {
          onPending?.call(true);
          if (responsePayment?.typePayment == EnumTypePayment.wave.value) {
            launch(responsePayment?.waveLaunchUrl ?? "");
          } else if (responsePayment?.typePayment ==
              EnumTypePayment.digitalpaye.value) {
            interfacePayment = EnumTypePayment.digitalpaye.value;
          } else if (responsePayment?.typePayment ==
              EnumTypePayment.mtn.value) {
            interfacePayment = EnumTypePayment.mtn.value;
          }
        } else {
          _statusPayment = EnumStatusPayment.successful;
          onSuccessful?.call(responsePayment!);
          onCallBack?.call(response.data!);
        }
        _showError = false;
      });
      notifyListeners();
    }
  }

  Future<void> startStatusPolling({required BuildContext context, required String token}) async {
    const Duration pollInterval = Duration(seconds: 10);
    const Duration totalPollingDuration = Duration(minutes: 3);
    Timer.periodic(pollInterval, (Timer timer) {
      getStatusPayment(token: token);
      totalMilliseconds += pollInterval.inMilliseconds;
      notifyListeners();
      DigitalpayeLogger.e("TIME_DELAY $totalMilliseconds");
      if (totalMilliseconds >= totalPollingDuration.inMilliseconds) {
        timer.cancel();
        isLoader = false;
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> getStatusPayment({required String token}) async {
    _isLoader = true;
    notifyListeners();
    final result = await repository.checkStatusTransaction(
        transactionId: responsePayment?.transactionId ?? "", token: token);
    result.fold((error) {
      if (error.codeStatus == 504) {
        _statusPayment = EnumStatusPayment.failed;
        responsePayment = error.data;
        onFailed?.call(responsePayment!);
        onCallBack?.call(error.data!);
      } else {
        _messageError = error.message;
        _showError = true;
        onError?.call(true);
      }
    }, (response) {
      if (response.codeStatus == 202) {
        onPending?.call(true);
      } else {
        _isLoader = false;
        _statusPayment = EnumStatusPayment.successful;
        onSuccessful?.call(responsePayment!);
        onCallBack?.call(response.data!);
      }
    });
    notifyListeners();
  }
  Future<void> generateToken() async {
    _isLoader = true;
    notifyListeners();
    final result = await repository.generateToken();
    result.fold((error) {
      showError = true;
    }, (response) {
      getAccessToken?.call(response.token ?? "");
    });
    _isLoader = false;
    notifyListeners();
  }
}
