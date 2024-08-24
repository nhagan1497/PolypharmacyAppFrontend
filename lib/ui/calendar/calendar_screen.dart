import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using hooks to manage state
    final calendarFormat = useState(CalendarFormat.month);
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState<DateTime?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Calendar Example'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay.value,
        calendarFormat: calendarFormat.value,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          return isSameDay(selectedDay.value, day);
        },
        onDaySelected: (newSelectedDay, newFocusedDay) {
          selectedDay.value = newSelectedDay;
          focusedDay.value = newFocusedDay; // update `focusedDay` here as well
        },
        onFormatChanged: (format) {
          if (calendarFormat.value != format) {
            calendarFormat.value = format;
          }
        },
        onPageChanged: (newFocusedDay) {
          focusedDay.value = newFocusedDay;
        },
      ),
    );
  }
}
