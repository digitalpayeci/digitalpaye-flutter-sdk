/// Enumation used to list all checklist template status
enum EnumTypePayment {
  unknown(value: "unknown"),
  digitalpaye(value: "DIGITALPAYE"),
  wave(value: "WAVE_CI"),
  mtn(value: "MTN_MONEY_CI"),
  orange(value: "ORANGE_MONEY_CI");

  final String value;

  /// Constructor

  const EnumTypePayment({required this.value});

  /// Factories

  static EnumTypePayment from({required String value}) =>
      EnumTypePayment.values.firstWhere(
        (element) => element.value == value,
        orElse: () => EnumTypePayment.unknown,
      );
  String get localizableValue {
    switch (this) {
      case EnumTypePayment.digitalpaye:
        return "Digitalpaye";
      case EnumTypePayment.wave:
        return "Wave Money";
      case EnumTypePayment.mtn:
        return "MTN Mobile Money";
      case EnumTypePayment.orange:
        return "Orange Money";
      default:
        return "N/A";
    }
  }

  String get svgUnSelected {
    switch (this) {
      case EnumTypePayment.digitalpaye:
        return "assets/images/digitalpaye_grey.png";
      case EnumTypePayment.wave:
        return "assets/images/wave_grey.png";
      case EnumTypePayment.mtn:
        return "assets/images/mtn_grey.png";
      case EnumTypePayment.orange:
        return "assets/images/orange_grey.png";
      default:
        return "N/A";
    }
  }

  String get svgSelected {
    switch (this) {
      case EnumTypePayment.digitalpaye:
        return "assets/images/digitalpaye.png";
      case EnumTypePayment.wave:
        return "assets/images/wave.png";
      case EnumTypePayment.mtn:
        return "assets/images/mtn.png";
      case EnumTypePayment.orange:
        return "assets/images/orange.png";
      default:
        return "N/A";
    }
  }
}
