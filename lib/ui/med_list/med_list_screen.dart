import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/services/med_list_state/med_list_state.dart';

import 'med_dialog.dart';

class MedListScreen extends ConsumerWidget {
  const MedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(medListStateProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ]
      ),
    );
  }
}
