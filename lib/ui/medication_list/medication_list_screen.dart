import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/medication_state/medication_state.dart';
import 'medication_screen.dart';
import 'medication_tile.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);
    final medicationStateActions = ref.watch(medicationStateProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          switch (medicationState) {
            AsyncData(:final value) => Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.refresh(medicationStateProvider.future),
                child: ListView.builder(
                  itemCount: value.medicationList.length + 1, // Add one more item for the SizedBox
                  itemBuilder: (context, index) {
                    if (index < value.medicationList.length) {
                      return MedicationTile(
                        medication: value.medicationList[index],
                      );
                    } else {
                      return const SizedBox(height: 80); // The SizedBox at the end
                    }
                  },
                ),
              ),
            ),
            AsyncError() => const Text('An unexpected error occurred.'),
            _ => const Expanded(child: Center(child: CircularProgressIndicator())),
          },
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          medicationStateActions.setSelectedMedication(null);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProviderScope(child: MedicationScreen()),
            ),
          );
        },
        icon: const Icon(Icons.medication_sharp),
        label: const Text('Add New Medication'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
