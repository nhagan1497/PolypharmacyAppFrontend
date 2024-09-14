import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/medication_state/medication_state.dart';
import '../../utilities/time_helpers.dart';

class MedicationRound extends HookConsumerWidget {
  final DateTime time;

  const MedicationRound({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsInRound = getMedicationsForTime(ref, time);

    // State for checkboxes: initializing it based on the number of medications
    final medicationChecked = useState<List<bool>>(List.generate(medicationsInRound?.length ?? 0, (index) => false));

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Slightly reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                formatTime(time),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...?medicationsInRound?.asMap().entries.map(
                  (entry) {
                final index = entry.key;
                final medication = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced vertical padding
                  child: GestureDetector(
                    onTap: () {
                      // Toggle the checkbox state when the row is tapped
                      medicationChecked.value = List.from(medicationChecked.value)
                        ..[index] = !medicationChecked.value[index];
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // Align items to the center
                      children: [
                          Checkbox(
                            value: medicationChecked.value[index],
                            onChanged: (bool? value) {
                              medicationChecked.value = List.from(medicationChecked.value)
                                ..[index] = value ?? false;
                            },
                          ),
                        Flexible( // Ensures text wraps properly if it's too long
                          child: Text(
                            '${medication['quantity']} x ${medication['name']} (${medication['dosage']})',
                            style: medicationChecked.value[index]
                                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                              decoration: TextDecoration.lineThrough, // Strikethrough
                              color: Colors.grey, // Grey out the text
                            )
                                : Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
