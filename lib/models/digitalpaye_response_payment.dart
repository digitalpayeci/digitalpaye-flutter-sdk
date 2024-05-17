import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_response_payment_interface.dart';

class DigitalpayeResponsePayment implements DigitalpayeResponsePaymentInterface {
  @override
  final String? linkpaymentId;
  @override
  final String? ref;
  @override
  final String? operatorId;
  @override
  final String? transactionId;
  @override
  final String? cardId;
  @override
  final String? numberUser;
  @override
  final String? nameUser;
  @override
  final String? emailUser;
  @override
  final String? countryUser;
  @override
  final String? currency;
  @override
  final String? amount;
  @override
  final String? fees;
  @override
  final String? amountReceive;
  @override
  final String? amountTotal;
  @override
  final String? status;
  @override
  final String? typeTransaction;
  @override
  final String? typePayment;
  @override
  final String? redirectUrl;
  @override
  final String? date;
  @override
  final String? dateUpdate;

  @override
  final String ? waveLaunchUrl;

  DigitalpayeResponsePayment({
    this.linkpaymentId,
    this.ref,
    this.operatorId,
    this.transactionId,
    this.cardId,
    this.numberUser,
    this.nameUser,
    this.emailUser,
    this.countryUser,
    this.currency,
    this.amount,
    this.fees,
    this.amountReceive,
    this.amountTotal,
    this.status,
    this.typeTransaction,
    this.typePayment,
    this.redirectUrl,
    this.date,
    this.dateUpdate,
    this.waveLaunchUrl,
  });

  factory DigitalpayeResponsePayment.fromJson(Map<String, dynamic> json) {
    return DigitalpayeResponsePayment(
      linkpaymentId: json['linkpayment_id'],
      ref: json['ref'],
      operatorId: json['operator_id'],
      transactionId: json['transaction_id'],
      cardId: json['cardId'],
      numberUser: json['number_user'],
      nameUser: json['name_user'],
      emailUser: json['email_user'],
      countryUser: json['country_user'],
      currency: json['currency'],
      amount: json['amount'],
      fees: json['fees'],
      amountReceive: json['amount_receive'],
      amountTotal: json['amount_total'],
      status: json['status'],
      typeTransaction: json['type_transaction'],
      typePayment: json['type_payment'],
      redirectUrl: json['redirectUrl'],
      date: json['date'],
      dateUpdate: json['date_update'],
      waveLaunchUrl: json['wave_launch_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'linkpayment_id': linkpaymentId,
      'ref': ref,
      'operator_id': operatorId,
      'transaction_id': transactionId,
      'cardId': cardId,
      'number_user': numberUser,
      'name_user': nameUser,
      'email_user': emailUser,
      'country_user': countryUser,
      'currency': currency,
      'amount': amount,
      'fees': fees,
      'amount_receive': amountReceive,
      'amount_total': amountTotal,
      'status': status,
      'type_transaction': typeTransaction,
      'type_payment': typePayment,
      'redirectUrl': redirectUrl,
      'date': date,
      'date_update': dateUpdate,
      'wave_launch_url': waveLaunchUrl,
    };
  }
}
