import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(),
  filter: null,
  output: null,
);

///  Log error
void errorLog(dynamic e, [StackTrace? s]) {
  logger.e(e, stackTrace: s);
}
