import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/ui/medication_list/remove_medication_button.dart';
import '../../models/medication/medication.dart';
import '../../services/medication_state/medication_state.dart';
import '../../utilities/time_helpers.dart';
import 'medication_screen.dart';

class MedicationTile extends ConsumerWidget {
  final Medication medication;

  const MedicationTile({super.key, required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationStateActions = ref.watch(medicationStateProvider.notifier);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication name and dosage
            Text(
              "${medication.name} - ${medication.dosage}",
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            // Medication schedules
            ListTile(
              subtitle: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: medication.schedules
                      .sorted((a, b) => compareTimeOfDay(a.time, b.time))
                      .map((sch) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              "• Take ${sch.quantity} at ${formatTime(sch.time)}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            // Edit and Delete buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    medicationStateActions.setSelectedMedication(medication);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MedicationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Oval shape
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                RemoveMedicationButton(medication: medication),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
