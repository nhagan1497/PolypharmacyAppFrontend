import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pill/pill.dart';
import '../../services/image_state/image_state.dart';

class IdentifiedPillScreen extends ConsumerWidget {
  final Pill discoveredPill;

  const IdentifiedPillScreen({
    super.key,
    required this.discoveredPill,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageState.image != null)
            // Adjust the size of the image here
              Container(
                width: 100, // Set the width as needed
                height: 100, // Set the height as needed
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Optional border
                  borderRadius: BorderRadius.circular(8), // Optional rounded corners
                ),
                child: Image.file(
                  File(imageState.image!.path),
                  fit: BoxFit.cover, // Adjust to fit the container
                ),
              ),
            const SizedBox(height: 20),
            Text(
              discoveredPill.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Text(
              discoveredPill.dosage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              discoveredPill.manufacturer,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
