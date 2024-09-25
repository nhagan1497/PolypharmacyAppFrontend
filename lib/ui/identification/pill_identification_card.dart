import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../../models/pill/pill.dart';

class PillIdentificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IMap<Pill, int> pills;

  const PillIdentificationCard({
    required this.title,
    required this.subtitle,
    required this.pills,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Keep other content left-aligned
          children: [
            Center( // Center the title
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Center( // Center the subtitle as well
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            // Create pill lines with left-aligned text
            ...pills.map((pill, quantity) {
              return MapEntry(
                pill,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '• $quantity x ${pill.name} (${pill.dosage})',
                    textAlign: TextAlign.left, // Left-aligned text for pill lines
                  ),
                ),
              );
            }).values,
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to log these medications
                },
                child: const Text("Log these medications"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
