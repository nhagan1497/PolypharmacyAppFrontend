import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/medication_state/medication_state.dart';
import '../../utilities/time_helpers.dart';

class MedicationRound extends ConsumerWidget {
  final DateTime time;

  const MedicationRound({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsInRound = getMedicationsForTime(ref, time);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatTime(time),
              style: Theme.of(context).textTheme.titleLarge
            ),
            const SizedBox(height: 8),
            ...?medicationsInRound?.map(
              (medication) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '${medication['quantity']}x ${medication['name']} (${medication['dosage']})',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
