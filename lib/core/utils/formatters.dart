import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Formats byte count to human-readable string (KB, MB).
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }

  /// Formats an Indian mobile number into `+91 XXXXX XXXXX`
  static String formatIndianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      return '+91 ${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    return phone;
  }

  /// Formats date time into readable Indian standard format.
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  /// Generates a unique reference ID for order submissions.
  /// Format: BHM-YYYYMMDD-XXXX (e.g. BHM-20261028-7492)
  static String generateReferenceId([DateTime? date]) {
    final now = date ?? DateTime.now();
    final datePart = DateFormat('yyyyMMdd').format(now);
    final randomPart = (1000 + (DateTime.now().microsecondsSinceEpoch % 9000))
        .toString();
    return 'BHM-$datePart-$randomPart';
  }

  /// Generates a initial default Order ID if none is set.
  static String generateInitialOrderId() {
    final year = DateTime.now().year;
    final randomSuffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
        .toString();
    return 'ORD-$year-$randomSuffix';
  }
}
