import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/ui/home/medication_round.dart';
import 'package:polypharmacy/services/medication_state/medication_state.dart';

import '../../services/pill_consumption_state/pill_consumption_state.dart';
import '../../utilities/time_helpers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);
    final pillConsumptionState = ref.watch(pillConsumptionStateProvider);

    return Scaffold(
      body: Column(
        children: [
          switch (medicationState) {
            AsyncData(:final value) => Expanded(
                child: RefreshIndicator(
                  onRefresh: () async =>
                      ref.refresh(medicationStateProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount:
                        getMedicationTimes(value.medicationList).length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${getGreeting()}, ${FirebaseAuth.instance.currentUser?.displayName?.split(" ").first}!",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "You have ${getMedicationTimes(value.medicationList).length} rounds of medication today.",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        );
                      }
                      final distinctTimes =
                          getMedicationTimes(value.medicationList);
                      final time = distinctTimes[index - 1];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MedicationRound(time: time),
                      );
                    },
                  ),
                ),
              ),
            AsyncError() => const Text('An unexpected error occurred.'),
            _ =>
              const Expanded(child: Center(child: CircularProgressIndicator())),
          },
        ],
      ),
    );
  }
}
