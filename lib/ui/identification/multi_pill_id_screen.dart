import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/ui/identification/pill_identification_card.dart';
import 'package:polypharmacy/utilities/custom_error_widget.dart';
import 'package:polypharmacy/utilities/custom_loading_widget.dart';
import '../../services/image_state/image_state.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pill_identification_state/pill_identification_state.dart';
import '../../utilities/time_helpers.dart';
import '../login/blue_box_decoration.dart';
import 'camera_screen.dart';

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
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: multiPillIdentificationState != null
                    ? multiPillIdentificationState.when(
                  data: (identificationResult) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                              title: "Correct Pills",
                              subtitle:
                              "These pills were correctly identified in the image:",
                              pills: identificationResult.correctPills,
                            ),
                          const SizedBox(height: 10),

                          // Missing Pills Section
                          if (identificationResult.missingPills
                              .isNotEmpty)
                            PillIdentificationCard(
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
                              title: "Unexpected Pills",
                              subtitle:
                              "These pills were found in the image, but are not supposed to be present:",
                              pills: identificationResult.unexpectedPills,
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
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
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
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
                              children: medicationsInRound.map((medication) {
                                final quantity = medication.schedules
                                    .firstWhere((schedule) =>
                                    isSameTime(schedule.time, time))
                                    .quantity;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Text(
                                    '$quantity x ${medication.name} (${medication.dosage})',
                                    style:
                                    Theme.of(context).textTheme.bodyLarge,
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
