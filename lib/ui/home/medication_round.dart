import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/pill_consumption/pill_consumption.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pill_consumption_state/pill_consumption_state.dart';
import '../../utilities/time_helpers.dart';

class MedicationRound extends HookConsumerWidget {
  final DateTime time;

  const MedicationRound({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider).value!;
    final medicationsInRound =
        medicationState.medicationRounds[getTimeOnly(time)];
    final pillConsumptions = ref.watch(pillConsumptionStateProvider).value!;
    final pillConsumptionActions =
        ref.read(pillConsumptionStateProvider.notifier);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                formatTime(time),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...?medicationsInRound?.map(
              (medication) {
                final quantity = medication.schedules
                    .firstWhere((schedule) => isSameTime(schedule.time, time))
                    .quantity;

                final loggedConsumption = pillConsumptions.firstWhereOrNull(
                    (pc) => pc.pillId == medication.pillId && pc.time == time);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0), // Reduced vertical padding
                  child: GestureDetector(
                    onTap: () {
                      if (loggedConsumption == null) {
                        pillConsumptionActions
                            .addPillConsumption(PillConsumption(
                          pillId: medication.pillId,
                          time: time,
                          quantity: quantity!,
                        ));
                      } else {
                        pillConsumptionActions
                            .deletePillConsumption(loggedConsumption);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: loggedConsumption != null,
                          onChanged: (bool? value) {
                            if (value == true) {
                              pillConsumptionActions
                                  .addPillConsumption(PillConsumption(
                                pillId: medication.pillId,
                                time: time,
                                quantity: quantity!,
                              ));
                            } else {
                              pillConsumptionActions
                                  .deletePillConsumption(loggedConsumption!);
                            }
                          },
                        ),
                        Flexible(
                          child: Text(
                            '$quantity x ${medication.name} (${medication.dosage})',
                            style: loggedConsumption != null
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      decoration: TextDecoration
                                          .lineThrough, // Strikethrough
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
