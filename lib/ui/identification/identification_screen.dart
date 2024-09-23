import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polypharmacy/utilities/custom_loading_widget.dart';
import '../../models/pill/pill.dart';
import '../../services/image_state/image_state.dart';
import '../../services/pill_identification_state/pill_identification_state.dart';
import 'identification_start_screen.dart';
import 'identified_pill_screen.dart';

class IdentificationScreen extends HookConsumerWidget {
  const IdentificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    AsyncValue<Pill>? pillIdentificationState;
    Pill? identifiedPill;

    if (imageState.imageFile != null) {
      pillIdentificationState =
          ref.watch(pillIdentificationStateProvider(imageState.imageFile!));
      if (pillIdentificationState?.value != null) {
        identifiedPill = pillIdentificationState!.value!;
      }
    }

    if (pillIdentificationState?.isLoading == true) {
      return const CustomLoadingWidget(loadingMessage: "Analyzing image...");
    } else if (identifiedPill != null) {
      return IdentifiedPillScreen(identifiedMedication: identifiedPill);
    } else {
      return const IdentifyMedicationStartScreen();
    }
  }
}

