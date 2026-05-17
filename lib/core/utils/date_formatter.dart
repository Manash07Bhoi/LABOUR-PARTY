import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatWithTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}
