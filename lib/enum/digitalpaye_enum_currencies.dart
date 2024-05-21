/// Enumation used to list all checklist template status
enum DigitalpayeEnumCurrencies {
  unknown(value: "unknown"),
  xof(value: "XOF");

  final String value;

  /// Constructor

  const DigitalpayeEnumCurrencies({required this.value});

  /// Factories

  static DigitalpayeEnumCurrencies from({required String value}) =>
      DigitalpayeEnumCurrencies.values.firstWhere(
        (element) => element.value == value,
        orElse: () => DigitalpayeEnumCurrencies.unknown,
      );
}
