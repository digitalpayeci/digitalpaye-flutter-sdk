enum DigitalpayeEnumCountries {
  unknown(value: "unknown"),
  ivoryCoast(value: "CI");

  final String value;

  /// Constructor

  const DigitalpayeEnumCountries({required this.value});

  /// Factories

  static DigitalpayeEnumCountries from({required String value}) =>
      DigitalpayeEnumCountries.values.firstWhere(
        (element) => element.value == value,
        orElse: () => DigitalpayeEnumCountries.unknown,
      );
}
