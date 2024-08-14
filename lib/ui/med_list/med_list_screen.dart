import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/services/med_list_state/med_list_state.dart';
import 'package:polypharmacy/ui/med_list/med_display_tile.dart';

import 'med_dialog.dart';

class MedListScreen extends ConsumerWidget {
  const MedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medList = ref.watch(medListStateProvider).valueOrNull;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: medList?.length ?? 0,
              itemBuilder: (context, index) {
                return MedDisplayTile(medication: medList![index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const MedDialog();
                  },
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
