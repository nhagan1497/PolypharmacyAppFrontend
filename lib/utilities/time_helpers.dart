import 'package:flutter/material.dart';

String formatTime(TimeOfDay time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';

  return '$hour:$minute $period';
}

String formatDateTime(DateTime dateTime) {
  final day = dateTime.day;
  final month = dateTime.month;
  final year = dateTime.year % 100; // Get last two digits of the year

  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';

  final dateFormatted = '$month/$day/$year';
  final timeFormatted = '$hour:$minute $period';

  return '$dateFormatted \n$timeFormatted';
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good morning';
  } else if (hour < 18) {
    return 'Good afternoon';
  } else {
    return 'Good evening';
  }
}

bool isSameTime(TimeOfDay time1, TimeOfDay time2) {
  return time1.hour == time2.hour && time1.minute == time2.minute;
}

DateTime getTimeOnly(DateTime time) {
  return DateTime(1970, 1, 1, time.hour, time.minute);
}
