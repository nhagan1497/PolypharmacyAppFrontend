import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/utilities/custom_error_widget.dart';

import '../../services/medication_state/medication_state.dart';
import '../../services/pill_consumption_state/pill_consumption_state.dart';
import 'medication_screen.dart';
import 'medication_tile.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);
    final medicationStateActions = ref.watch(medicationStateProvider.notifier);
    ref.watch(pillConsumptionStateProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: switch (medicationState) {
              AsyncData(:final value) => RefreshIndicator(
                  onRefresh: () async =>
                      ref.refresh(medicationStateProvider.future),
                  child: value.medicationList.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Symbols.pill, // Use Symbols.pill if necessary
                                size: 80, // Adjust icon size as needed
                                color: Colors.blue, // Customize color
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Add prescriptions to your account using the button below.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                              bottom: 80), // Add padding to avoid overlap
                          itemCount: value.medicationList.length,
                          itemBuilder: (context, index) {
                            return MedicationTile(
                              medication: value.medicationList[index],
                            );
                          },
                        ),
                ),
              AsyncError() => const CustomErrorWidget(
                  errorMessage:
                      "An error occurred while fetching medications. Please try again later."),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Center(
              child: SizedBox(
                width: 200, // Set a fixed width for the button
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MedicationScreen(),
                      ),
                    );
                    medicationStateActions.setSelectedMedication(null);
                  },
                  icon: const Icon(Icons.medication_sharp),
                  label: const Text('Add New Medication'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 6.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
