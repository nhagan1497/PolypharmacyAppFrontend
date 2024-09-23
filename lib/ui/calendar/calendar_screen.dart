import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../services/medication_state/medication_state.dart';
import '../home/medication_round.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);
    final calendarFormat = useState(CalendarFormat.twoWeeks);
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState<DateTime>(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            locale: 'en_US',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay.value,
            calendarFormat: calendarFormat.value,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.lightBlue[400],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue[900],
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay.value, day);
            },
            onDaySelected: (newSelectedDay, newFocusedDay) {
              selectedDay.value = newSelectedDay;
              focusedDay.value = newFocusedDay;
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
          // MedicationRounds as a list below the calendar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount:
                  medicationState.value?.medicationRounds.keys.length ?? 0,
              itemBuilder: (context, index) {
                final ingestionTime = medicationState
                    .value?.medicationRounds.keys
                    .elementAt(index);

                final medicationDateTime = DateTime(
                  selectedDay.value.year,
                  selectedDay.value.month,
                  selectedDay.value.day,
                  ingestionTime?.hour ?? 0,
                  ingestionTime?.minute ?? 0,
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MedicationRound(time: medicationDateTime),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
