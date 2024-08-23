import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/ui/home/medication_round.dart';
import 'package:polypharmacy/services/medication_state/medication_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);

    return Scaffold(
      body: Column(
        children: [
          switch (medicationState) {
            AsyncData(:final value) => Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.refresh(medicationStateProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: value.medicationList
                      .expand((medication) => medication.schedules.map((schedule) => schedule.time))
                      .toSet()
                      .length,
                  itemBuilder: (context, index) {
                    final distinctTimes = value.medicationList
                        .expand((medication) => medication.schedules.map((schedule) => schedule.time))
                        .toSet()
                        .toList()
                      ..sort((a, b) => a.compareTo(b));

                    final time = distinctTimes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MedicationRound(time: time),
                    );
                  },
                ),
              ),
            ),
            AsyncError() => const Text('An unexpected error occurred.'),
            _ => const Expanded(child: Center(child: CircularProgressIndicator())),
          },
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
