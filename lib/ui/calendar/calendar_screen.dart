import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../services/medication_state/medication_state.dart';
import '../../utilities/custom_error_widget.dart';
import '../home/medication_round.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);
    final calendarFormat = useState(CalendarFormat.twoWeeks);
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState<DateTime>(DateTime.now());

    return Column(
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
        Expanded(
          child: medicationState.when(
            data: (medicationData) {
              final sortedTimes =
                  getMedicationTimes(medicationData.medicationList);
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: sortedTimes.length,
                itemBuilder: (context, index) {
                  final ingestionTime = sortedTimes.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: MedicationRound(
                      time: ingestionTime,
                      date: selectedDay.value,
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const CustomErrorWidget(
              errorMessage:
                  "An error occurred while fetching medications. Please try again later.",
            ),
          ),
        ),
      ],
    );
  }
}
