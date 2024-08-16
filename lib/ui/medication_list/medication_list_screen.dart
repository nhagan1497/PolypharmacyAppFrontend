import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/medication_state/medication_state.dart';
import 'medication_screen.dart';
import 'medication_tile.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicationStateProvider).valueOrNull;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: medications?.length ?? 0,
              itemBuilder: (context, index) {
                return MedicationTile(medication: medications![index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MedicationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.medical_services, size: 20),
              label: const Text('Add New Medication'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Oval shape
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
