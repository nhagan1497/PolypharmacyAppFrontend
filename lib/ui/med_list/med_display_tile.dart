import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/models/user_medication/user_medication.dart';

class MedDisplayTile extends ConsumerWidget {
  final UserMedication medication;

  const MedDisplayTile({super.key, required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      const Divider(
        color: Colors.grey,
        height: 20,
        thickness: 2,
        indent: 10,
        endIndent: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${medication.name} - ${medication.dosage}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your edit functionality here
                  },
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Oval shape
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Space between buttons
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your delete functionality here
                  },
                  icon: const Icon(Icons.delete, size: 20),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Oval shape
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ListTile(
        subtitle: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: medication.dailyAdministrations.entries
                .map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "Take ${entry.value} pills at ${entry.key}",
                style: const TextStyle(color: Colors.black),
              ),
            ))
                .toList(),
          ),
        ),
      ),
    ]);
  }
}
