import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/models/user_medication/user_medication.dart';

class MedDisplayTile extends ConsumerWidget {
  final UserMedication medication;

  const MedDisplayTile({super.key, required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      const Divider(
        color: Colors.grey, // Color of the divider
        height: 20, // Space around the divider
        thickness: 2, // Thickness of the divider line
        indent: 10, // Start padding
        endIndent: 10, // End padding
      ),
      ListTile(
        title: Text("${medication.name} - ${medication.dosage}"),
        subtitle: Row(
          children: medication.timesOfDay
              .map((time) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      backgroundColor: Colors.purple,
                      label: Text(
                        time,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
              .toList(),
        ),
        trailing: Text('Take: ${medication.quantity}'),
      ),
    ]);
  }
}
