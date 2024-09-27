import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/models/medication/medication.dart';
import 'package:polypharmacy/utilities/custom_error_widget.dart';
import 'package:polypharmacy/utilities/custom_loading_widget.dart';
import '../../services/image_state/image_state.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pill_identification_state/pill_identification_state.dart';
import '../../utilities/time_helpers.dart';
import '../login/blue_box_decoration.dart';
import 'camera_screen.dart';
import 'multi_pill_identification_result.dart';

class MultiPillIdScreen extends ConsumerWidget {
  final TimeOfDay time;
  final DateTime date;

  const MultiPillIdScreen({required this.time, required this.date, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider).value!;
    final medicationsInRound = medicationState.medicationRounds[time];
    final imageState = ref.watch(imageStateProvider);

    AsyncValue<MultiPillIdentificationResult>? multiPillIdentificationState;
    if (imageState.imageFile != null) {
      multiPillIdentificationState = ref.watch(
          multiPillIdentificationStateProvider(imageState.imageFile!, time));
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: blueBoxDecoration,
        ),
        centerTitle: true,
        title: const Text(
          "Multi Pill ID",
          style: TextStyle(fontSize: 36),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: multiPillIdentificationState != null
                        ? multiPillIdentificationState.when(
                            data: (identificationResult) {
                              return MultiPillIdentificationResultDisplay(
                                time: time,
                                date: date,
                                identificationResult: identificationResult,
                              );
                            },
                            loading: () => const Center(
                              child: CustomLoadingWidget(
                                  loadingMessage: "Analyzing image..."),
                            ),
                            error: (error, stackTrace) => const Center(
                              child: CustomErrorWidget(
                                  errorMessage:
                                      "An error occurred while identifying medications. Please try again later."),
                            ),
                          )
                        : MultiPillIdStart(
                            time: time, medicationsInRound: medicationsInRound),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiPillIdStart extends StatelessWidget {
  const MultiPillIdStart({
    super.key,
    required this.time,
    required this.medicationsInRound,
  });

  final TimeOfDay time;
  final List<Medication>? medicationsInRound;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Symbols.search_check_2,
                size: 100.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Place the following medication for your ${formatTime(time)} round on a table and take a picture:",
              style: const TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            if (medicationsInRound != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: medicationsInRound!.map((medication) {
                  final quantity = medication.schedules
                      .firstWhere((schedule) => isSameTime(schedule.time, time))
                      .quantity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '$quantity x ${medication.name} (${medication.dosage})',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.left,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CameraScreen(
                        appBarText: "Multi Pill Picture",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Open Camera'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
