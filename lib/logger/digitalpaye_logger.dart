import 'package:logger/logger.dart';

enum DigitalpayeLoggerType { debug, info, warning, error }

abstract class DigitalpayeLogger {
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, DigitalpayeLoggerType.debug, error, stackTrace);
  }

  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, DigitalpayeLoggerType.info, error, stackTrace);
  }

  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, DigitalpayeLoggerType.warning, error, stackTrace);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, DigitalpayeLoggerType.error, error, stackTrace);
  }

  static void log(String message, DigitalpayeLoggerType type,
      [dynamic error, StackTrace? stackTrace]) {
    var logger = Logger();

    switch (type) {
      case DigitalpayeLoggerType.debug:
        logger.d(message, error: error, stackTrace: stackTrace);
        break;
      case DigitalpayeLoggerType.info:
        logger.i(message, error: error, stackTrace: stackTrace);
        break;
      case DigitalpayeLoggerType.warning:
        logger.w(message, error: error, stackTrace: stackTrace);
        break;
      case DigitalpayeLoggerType.error:
        logger.e(message, error: error, stackTrace: stackTrace);
        break;
    }
  }
}
