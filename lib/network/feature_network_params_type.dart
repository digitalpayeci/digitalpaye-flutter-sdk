enum FeatureNetworkParamsType {
  TEMPERATURE,
  TRACABILITY,
  RECEPTION_CHECK,
  HEATING,
  TEMPERATURE_KEEPING,
  CLEANING,
  OIL_MANAGEMENT,
  RICE_PH,
  EXPEDITION_CHECK
}

extension FeatureNetworkParamsTypeExtension on FeatureNetworkParamsType {
  String get statementName {
    switch (this) {
      case FeatureNetworkParamsType.TEMPERATURE:
        return "temperaturesStatement";
      case FeatureNetworkParamsType.TRACABILITY:
        return "tracabilitiesStatement";
      case FeatureNetworkParamsType.RECEPTION_CHECK:
        return "receptionCheckStatement";
      case FeatureNetworkParamsType.HEATING:
        return "heatingStatement";
      case FeatureNetworkParamsType.TEMPERATURE_KEEPING:
        return "statementId";
      case FeatureNetworkParamsType.CLEANING:
      case FeatureNetworkParamsType.RICE_PH:
      case FeatureNetworkParamsType.EXPEDITION_CHECK:
        return "statementId";
      case FeatureNetworkParamsType.OIL_MANAGEMENT:
        return "oilManagementStatementId";
      default:
        return "";
    }
  }
}
