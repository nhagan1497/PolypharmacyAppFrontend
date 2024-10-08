import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/ui/identification/multi_pill_id_screen.dart';
import '../../models/pill_consumption/pill_consumption.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pill_consumption_state/pill_consumption_state.dart';
import '../../utilities/time_helpers.dart';

class MedicationRound extends HookConsumerWidget {
  final TimeOfDay time;
  final DateTime date;

  const MedicationRound({
    super.key,
    required this.time,
    required this.date,
  });

  DateTime getCombinedDateTime() {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider).value!;
    final medicationsInRound = medicationState.medicationRounds[time];
    final pillConsumptionAsyncValue = ref.watch(pillConsumptionStateProvider);
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
            // Handle loading and error states
            pillConsumptionAsyncValue.when(
              data: (pillConsumptions) {
                // Check if any consumptions are logged for this round
                final hasCheckedPills = medicationsInRound?.any((medication) {
                      return pillConsumptions.any((pc) =>
                          pc.pillId == medication.pillId &&
                          pc.time == getCombinedDateTime());
                    }) ??
                    false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...?medicationsInRound?.map(
                      (medication) {
                        final quantity = medication.schedules
                            .firstWhere(
                                (schedule) => isSameTime(schedule.time, time))
                            .quantity;

                        final loggedConsumption =
                            pillConsumptions.firstWhereOrNull((pc) =>
                                pc.pillId == medication.pillId &&
                                pc.time == getCombinedDateTime());

                        return GestureDetector(
                          onTap: () {
                            if (loggedConsumption == null) {
                              pillConsumptionActions.addPillConsumption(
                                PillConsumption(
                                  pillId: medication.pillId,
                                  time: getCombinedDateTime(),
                                  quantity: quantity,
                                ),
                              );
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
                                    pillConsumptionActions.addPillConsumption(
                                      PillConsumption(
                                        pillId: medication.pillId,
                                        time: getCombinedDateTime(),
                                        quantity: quantity,
                                      ),
                                    );
                                  } else {
                                    pillConsumptionActions
                                        .deletePillConsumption(
                                            loggedConsumption!);
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
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          )
                                      : Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    if (!hasCheckedPills)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MultiPillIdScreen(time: time, date: date),
                              ),
                            );
                          },
                          icon: const Icon(Symbols.search_check_2),
                          label: const Text('Verify with Pill ID'),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error loading pill consumptions: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
