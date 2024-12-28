import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    // methodCount: 0,
    printEmojis: true, // Print an emoji for each log message
    // Should each log print contain a timestamp
  ),
  filter: null,
  output: null,
);

///  Log error
void errorLog(dynamic e, [StackTrace? s]) {
  logger.e(e, stackTrace: s);
}
