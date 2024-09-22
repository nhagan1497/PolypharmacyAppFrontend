import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pill/pill.dart';
import '../../services/image_state/image_state.dart';

class IdentifiedPillScreen extends ConsumerWidget {
  final Pill identifiedMedication;

  const IdentifiedPillScreen({
    super.key,
    required this.identifiedMedication,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${identifiedMedication.name} - ${identifiedMedication.dosage}",
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            if (imageState.imageMultipartFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Rounding the corners
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Optional border
                  ),
                  child: Image.file(
                    File(imageState.imageXFile!.path),
                    fit: BoxFit.cover, // Adjust to fit the container
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.invalidate(imageStateProvider),
              child: const Text('Take New Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
