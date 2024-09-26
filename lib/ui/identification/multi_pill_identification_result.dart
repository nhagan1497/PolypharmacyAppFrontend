import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/services/pill_identification_state/pill_identification_state.dart';
import 'package:polypharmacy/ui/identification/pill_identification_card.dart';

import '../../services/image_state/image_state.dart';

class MultiPillIdentificationResultDisplay extends ConsumerWidget {
  final MultiPillIdentificationResult identificationResult;
  final TimeOfDay time;
  final DateTime date;
  const MultiPillIdentificationResultDisplay({
    super.key,
    required this.identificationResult,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.file(
                imageState.imageFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Correct Pills Section
        if (identificationResult.correctPills
            .isNotEmpty)
          PillIdentificationCard(
            time: time,
            date: date,
            title: "Verified Pills",
            subtitle:
            "These pills were verified in the image to be correct for this round:",
            pills: identificationResult.correctPills,
          ),
        const SizedBox(height: 10),

        // Missing Pills Section
        if (identificationResult.missingPills
            .isNotEmpty)
          PillIdentificationCard(
            time: time,
            date: date,
            title: "Missing Pills",
            subtitle:
            "These pills were expected in the image, but not found:",
            pills: identificationResult.missingPills,
          ),
        const SizedBox(height: 10),

        // Unexpected Pills Section
        if (identificationResult.unexpectedPills
            .isNotEmpty)
          PillIdentificationCard(
            time: time,
            date: date,
            title: "Unexpected Pills",
            subtitle:
            "These pills were found in the image, but are not supposed to be present:",
            pills: identificationResult.unexpectedPills,
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
