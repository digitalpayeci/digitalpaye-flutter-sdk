enum NetworkApiVersions {
  v1,
  v2;

  String get value {
    switch (this) {
      case NetworkApiVersions.v1:
        return "v1";
      case NetworkApiVersions.v2:
        return "v2";
    }
  }
}
