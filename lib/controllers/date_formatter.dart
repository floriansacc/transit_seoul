class DateFormatter {
  static DateTime? toDate(String? dateString) {
    if (dateString == null) return null;

    String dateWithT =
        '${dateString.substring(0, 8)}T${dateString.substring(8)}';

    return DateTime.parse(dateWithT);
  }
}
