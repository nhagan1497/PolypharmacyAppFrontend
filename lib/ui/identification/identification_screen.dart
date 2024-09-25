import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polypharmacy/services/medication_state/medication_state.dart';
import 'package:polypharmacy/services/pill_consumption_state/pill_consumption_state.dart';
import 'package:polypharmacy/services/schedule_state/schedule_state.dart';
import 'package:polypharmacy/utilities/custom_loading_widget.dart';
import '../../models/pill/pill.dart';
import '../../services/image_state/image_state.dart';
import '../../services/pill_identification_state/pill_identification_state.dart';
import 'identification_start.dart';
import 'identified_pill.dart';

class IdentificationScreen extends HookConsumerWidget {
  const IdentificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pillConsumptionStateProvider);
    ref.watch(medicationStateProvider);
    ref.watch(scheduleStateProvider);
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
      return IdentifiedPill(identifiedMedication: identifiedPill);
    } else {
      return const IdentifyMedicationStart();
    }
  }
}
