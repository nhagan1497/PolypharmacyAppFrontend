import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/medication/medication.dart';
import '../../services/medication_state/medication_state.dart';

class RemoveMedicationButton extends ConsumerWidget {
  final Medication medication;

  const RemoveMedicationButton({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationStateActions = ref.watch(medicationStateProvider.notifier);

    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Remove ${medication.name}?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Remove"),
                    onPressed: () {
                      medicationStateActions
                          .deleteSchedulesForMedication(medication);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      icon: const Icon(Icons.delete, size: 20),
      label: const Text('Remove'),
      style: ElevatedButton.styleFrom(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Oval shape
        ),
      ),
    );
  }
}
