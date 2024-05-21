/// Enumation used to list all checklist template status
enum EnumStatusPayment {
  unknown(value: "unknown"),
  failed(value: "FAILED"),
  cancel(value: "CANCEL"),
  pending(value: "PENDING"),
  successful(value: "SUCCESSFUL");

  final String value;

  /// Constructor

  const EnumStatusPayment({required this.value});

  /// Factories

  static EnumStatusPayment from({required String value}) =>
      EnumStatusPayment.values.firstWhere(
        (element) => element.value == value,
        orElse: () => EnumStatusPayment.unknown,
      );
}
