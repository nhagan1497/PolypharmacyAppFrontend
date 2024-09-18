import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/pill/pill.dart';
import '../../services/image_state/image_state.dart';
import '../../services/pill_identification_state/pill_identification_state.dart';
import 'camera_preview_screen.dart';
import 'identified_pill_screen.dart';

class IdentificationScreen extends HookConsumerWidget {
  const IdentificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    AsyncValue<Pill>? pillIdentificationState;
    Pill? identifiedPill;

    if (imageState.imageBase64 != null) {
      pillIdentificationState =
          ref.watch(pillIdentificationStateProvider(imageState.imageBase64!));
      if (pillIdentificationState?.value != null) {
        identifiedPill = pillIdentificationState!.value!;
      }
    }

    if (pillIdentificationState?.isLoading == true) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (identifiedPill != null) {
      return IdentifiedPillScreen(discoveredPill: identifiedPill);
    } else {
      return const IdentifyMedicationStartScreen();
    }
  }
}

class IdentifyMedicationStartScreen extends StatelessWidget {
  const IdentifyMedicationStartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Use Pill ID artificial intelligence to analyze pictures of any medication you may have dropped or spilled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to camera preview screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderScope(child: CameraPreviewScreen()),
                  ),
                );
              },
              child: const Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
