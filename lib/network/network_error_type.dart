enum NetworkErrorType {
  BadRequestException,
  BadGeteway,
  FetchDataException,
  NotFoundException,
  InternalServerError,
  NoInternetConnection,
  Forbidden,
  platformMissing,
  Unknown;

  static NetworkErrorType fromCode(int code) {
    switch (code) {
      case 400:
        return NetworkErrorType.BadRequestException;
      case 403:
        return NetworkErrorType.Forbidden;
      case 404:
        return NetworkErrorType.NotFoundException;
      case 500:
        return NetworkErrorType.InternalServerError;
      case 502:
        return NetworkErrorType.BadGeteway;
      default:
        return NetworkErrorType.Unknown;
    }
  }
}
