class PaymentNetworkApis {
  static String fetchDataPayment({required String token}) {
    return "/payment/data-link-payment/$token";
  }

  static String checkStatusTransaction({required String transactionId}) {
    return "/get-status-payment-link/$transactionId";
  }

  static String initializePayment = "/payment/create-payment-link";
  static String cancelPayment = "/payment/cancel-payment-link";
}
