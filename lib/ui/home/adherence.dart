import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/pill/pill.dart';
import '../../services/pill_identification_state/pill_identification_state.dart';
import '../../utilities/time_helpers.dart';

class Adherence extends HookConsumerWidget {
  final TimeOfDay time;
  final DateTime date;

  const Adherence({
    super.key,
    required this.time,
    required this.date,
  });

  DateTime getCombinedDateTime() {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adherenceResult = getAdherence(ref, time, date);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                formatTime(time),
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...adherenceResult.correctPills.entries.map((entry) {
                  final pill = entry.key;
                  final quantity = entry.value;
                  return _buildAdherenceRow(
                    context,
                    pill,
                    quantity,
                    Icons
                        .check_circle_outline,
                    // Green checkmark for correct pills
                    Colors.green,
                  );
                }),
                ...adherenceResult.missingPills.entries.map((entry) {
                  final pill = entry.key;
                  final quantity = entry.value;
                  return _buildAdherenceRow(
                    context,
                    pill,
                    quantity,
                    Icons.help_outline, // Blue question mark for missing pills
                    Colors.blue,
                  );
                }),
                ...adherenceResult.unexpectedPills.entries.map((entry) {
                  final pill = entry.key;
                  final quantity = entry.value;
                  return _buildAdherenceRow(
                    context,
                    pill,
                    quantity,
                    Icons.error_outline, // Red alert for unexpected pills
                    Colors.red,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdherenceRow(BuildContext context, Pill pill, int quantity,
      IconData icon, Color iconColor) {
    String helpText;
    if (iconColor == Colors.green) {
      helpText = 'This medication was taken as expected.';
    } else if (iconColor == Colors.blue) {
      helpText = 'This medication is expected but has not been taken.';
    } else if (iconColor == Colors.red) {
      helpText = 'This medication was taken unexpectedly.';
    } else {
      helpText = 'Unknown adherence status.';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            showDuration: const Duration(seconds: 5),
            triggerMode: TooltipTriggerMode.tap,
            message: helpText,
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$quantity x ${pill.name} (${pill.dosage})',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}