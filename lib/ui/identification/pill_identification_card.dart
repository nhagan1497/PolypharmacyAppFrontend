import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polypharmacy/services/pill_consumption_state/pill_consumption_state.dart';

import '../../models/pill/pill.dart';
import '../../models/pill_consumption/pill_consumption.dart';

class PillIdentificationCard extends HookConsumerWidget {
  final String title;
  final String subtitle;
  final IMap<Pill, int> pills;
  final TimeOfDay time;
  final DateTime date;

  const PillIdentificationCard({
    required this.time,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.pills,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumptionStateActions = ref.watch(pillConsumptionStateProvider.notifier);
    final pillsTaken = useState<bool>(false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            ...pills.map((pill, quantity) {
              return MapEntry(
                pill,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '• $quantity x ${pill.name} (${pill.dosage})',
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }).values,
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: pillsTaken.value
                    ? null
                    : () {
                        pillsTaken.value = true;
                        for (final entry in pills.entries) {
                          final pill = entry.key;
                          final quantity = entry.value;
                          final pillConsumption = PillConsumption(
                            pillId: pill.id,
                            quantity: quantity,
                            time: DateTime(date.year, date.month, date.day, time.hour, time.minute),
                          );
                          consumptionStateActions
                              .addPillConsumption(pillConsumption);
                        }
                      },
                icon: Icon(!pillsTaken.value
                    ? Icons.check_box_outline_blank
                    : Icons.check_box_outlined),
                label: Text(!pillsTaken.value ? 'Mark as Taken' : "Taken"),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
