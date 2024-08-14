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

    return Center(
      child: Column(children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const MedDialog();
              },
            );
          },
          child: const Text('Add New Medication'),
        ),
        const SizedBox(height: 8),
        ...?medList
            ?.map((medication) => MedDisplayTile(medication: medication)),
      ]),
    );
  }
}
