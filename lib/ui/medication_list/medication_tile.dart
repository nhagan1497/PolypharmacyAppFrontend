import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/ui/medication_list/remove_medication_button.dart';
import '../../models/medication/medication.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pill_count_state/dart/pill_count_state.dart';
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
      child: Stack(
        children: [
          Padding(
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
                Text(
                  medication.manufacturer,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          // Pill count display in the top-right corner
          PillCountChip(medication: medication,),
        ],
      ),
    );
  }
}

class PillCountChip extends ConsumerWidget {
  const PillCountChip({
    super.key,
    required this.medication,
  });

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillCountAsync = ref.watch(pillCountStateProvider(medication.pillId));
    final pillCountStateActions = ref.watch(pillCountStateProvider(medication.pillId).notifier);

    return Positioned(
      top: 8,
      right: 8,
      child: pillCountAsync.when(
        data: (pillCount) => GestureDetector(
          onTap: () {
            // Action to update pill count can be handled here
            showDialog(
              context: context,
              builder: (context) {
                TextEditingController pillCountController = TextEditingController();

                return AlertDialog(
                  title: const Text("Refill Prescription"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: pillCountController,
                        keyboardType: TextInputType.number,  // Ensures only numbers are entered
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New pill count',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);  // Close the dialog without saving
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Get the entered pill count
                        final newPillCount = int.tryParse(pillCountController.text);
                        if (newPillCount != null) {
                          pillCountStateActions.updatePillCount(medication.pillId, newPillCount);
                        }
                        Navigator.pop(context);  // Close the dialog
                      },
                      child: const Text("Update"),
                    ),
                  ],
                );
              },
            );

          },
          child: Chip(
            label: Text('$pillCount'),
            backgroundColor: Colors.blue.shade100,
            side: BorderSide.none,  // Removes the black border
            avatar: const Icon(Symbols.pill, size: 18), // Add an icon to indicate refill action
          ),
        ),
        loading: () => const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (error, stack) => const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
