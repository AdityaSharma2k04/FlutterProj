import 'package:flutter/material.dart';

class TimeFormatter {
  /// Returns time string either as 'HH:mm' if today or '4 Apr' if earlier.
  static String formatEpochToTime({required BuildContext context, required String epoch}) {
    try {
      final int milliseconds = int.parse(epoch);
      final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      final now = DateTime.now();

      if (DateUtils.isSameDay(now, dateTime)) {
        return TimeOfDay.fromDateTime(dateTime).format(context);
      } else {
        return '${dateTime.day} ${_getMonth(dateTime.month)}';
      }
    } catch (e) {
      return 'Invalid time';
    }
  }

  static String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Invalid';
    }
  }
}
