enum EnumResponseNetwork {
  unknown("unknown"),
  transactionDelayed("TRANSACTION_DELAYED_RETRY_IN_5_MINUTES"),
  transactionIdMaxLengthExceeded("TRANSACTION_ID_MAX_LENGHT_20"),
  operatorUnavailable("OPERATOR_IS_UNAVAILABLE"),
  amountInsufficient("AMOUNT_USER_INSUFFISANT"),
  userNotMtnMoney("USER_NOT_MTN_MONEY"),
  transactionDuplicated("TRANSACTION_DUPLICATED"),
  internalError("ERROR_INTERNE_TRY_AGAIN"),
  operatorNoSupported("OPERATOR_NO_SUPPORTED");

  final String value;

  /// Constructor
  const EnumResponseNetwork(this.value);

  /// Factories
  static EnumResponseNetwork from({required String value}) =>
      EnumResponseNetwork.values.firstWhere(
        (element) => element.value == value,
        orElse: () => EnumResponseNetwork.unknown,
      );

  /// Localizable descriptions in French
  String get localizableValue {
    switch (this) {
      case EnumResponseNetwork.transactionDelayed:
        return "Transaction retardée, réessayez dans 5 minutes";
      case EnumResponseNetwork.transactionIdMaxLengthExceeded:
        return "Longueur maximale de l'ID de transaction dépassée (20 caractères)";
      case EnumResponseNetwork.operatorUnavailable:
        return "L'opérateur est indisponible";
      case EnumResponseNetwork.amountInsufficient:
        return "Montant insuffisant pour l'utilisateur";
      case EnumResponseNetwork.userNotMtnMoney:
        return "L'utilisateur n'est pas sur MTN Money";
      case EnumResponseNetwork.transactionDuplicated:
        return "Transaction dupliquée";
      case EnumResponseNetwork.internalError:
        return "Erreur interne, réessayez";
      case EnumResponseNetwork.operatorNoSupported:
        return "Opérateur non supporté";
      default:
        return "Une erreur est survenue lors du paiement.";
    }
  }
}
