// CLass used to format body as hygie server needed
class HGNetworkBodyFormater {
  /// Holds
  final Map<String, dynamic> jsonData;

  /// Returns
  Map<String, dynamic> get formattedData => {
        "params": {
          "data": jsonData,
        }
      };

  /// Constructor
  HGNetworkBodyFormater({required this.jsonData});
}
