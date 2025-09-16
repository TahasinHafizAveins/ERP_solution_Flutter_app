import 'package:logger/logger.dart';

class Config {
  static const String baseUrl = "https://nagaderp.mynagad.com:7070";
  static const int timeout = 120;
  static const String loginUrl = "/Security/User/SignInWithMenus";
}

/// Common logger
final Logger log = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // Number of method calls to be displayed
    errorMethodCount: 10, // Number of method calls if stacktrace is provided
    lineLength: 92, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    dateTimeFormat: DateTimeFormat
        .onlyTimeAndSinceStart, // Should each log print contain a timestamp
  ),
);
