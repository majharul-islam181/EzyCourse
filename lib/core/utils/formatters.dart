import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String toReadable(final DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String toReadableWithTime(final DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  static String toIso8601(final DateTime date) {
    return date.toIso8601String();
  }

  static String timeAgo(final DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static String countdown(final DateTime endDate) {
    final Duration diff = endDate.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    final int days = diff.inDays;
    final int hours = diff.inHours % 24;
    final int minutes = diff.inMinutes % 60;
    if (days > 0) return '${days}d ${hours}h';
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(final double amount, {final String symbol = '\$'}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(amount);
  }

  static String compact(final double amount) {
    return NumberFormat.compact().format(amount);
  }
}
