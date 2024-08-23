import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/medication_state/medication_state.dart';

class MedicationRound extends ConsumerWidget {
  final DateTime time;

  const MedicationRound({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider).valueOrNull;

    // Filter medications by the given time and map to include dosage and quantity
    final medicationsInRound = medicationState?.medicationList
        .where((medication) =>
            medication.schedules.any((schedule) => schedule.time == time))
        .expand((medication) => medication.schedules
            .where((schedule) => schedule.time == time)
            .map((schedule) => {
                  'name': medication.name,
                  'dosage': medication.dosage,
                  'quantity': schedule.quantity
                }))
        .toList();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatTime(time),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...?medicationsInRound?.map(
              (medication) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${medication['quantity']}x ${medication['name']} (${medication['dosage']})',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

}
