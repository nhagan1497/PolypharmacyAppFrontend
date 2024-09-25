import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polypharmacy/ui/login/blue_box_decoration.dart';
import 'package:polypharmacy/utilities/custom_error_widget.dart';
import 'package:polypharmacy/utilities/custom_loading_widget.dart';

import '../../models/pill/pill.dart';
import '../../services/image_state/image_state.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pills_state/pills_state.dart';
import '../identification/camera_screen.dart';

class MedicationCreateScreen extends HookConsumerWidget {
  const MedicationCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final dosageController = useTextEditingController();
    final manufacturerController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    final imageState = ref.watch(imageStateProvider);
    final pillsState = ref.watch(pillsStateProvider);
    final pillsStateActions = ref.watch(pillsStateProvider.notifier);
    final currentlySelectedMedication =
        ref.watch(medicationStateProvider).value?.selectedMedication;
    final submitPressed =
        useState(false); // Tracks if the submit button was pressed

    // Pop the screen if currentlySelectedMedication is not null
    useEffect(() {
      if (currentlySelectedMedication != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
      return null;
    }, [currentlySelectedMedication]);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: blueBoxDecoration,
        ),
        centerTitle: true,
        title: const Text(
          "New Medication",
          style: TextStyle(
            fontSize: 36,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pillsState.when(
          loading: () => const Center(
            child:
                CustomLoadingWidget(loadingMessage: "Submitting medication..."),
          ),
          error: (error, stackTrace) => const Center(
            child: CustomErrorWidget(
                errorMessage:
                    "An error occured while submitting a new medication. Please try again later."),
          ),
          data: (pillsData) => SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: dosageController,
                        decoration: const InputDecoration(
                          labelText: 'Dosage',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the dosage';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: manufacturerController,
                        decoration: const InputDecoration(
                          labelText: 'Manufacturer',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the manufacturer';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      if (imageState.imageFile != null)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8), // Rounding the corners
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey), // Optional border
                              ),
                              child: Image.file(
                                imageState.imageFile!,
                                fit:
                                    BoxFit.cover, // Adjust to fit the container
                              ),
                            ),
                          ),
                        ),
                      if (submitPressed.value && imageState.imageFile == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: Text(
                              'Please take picture of medication',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CameraScreen(appBarText: "New Med Picture"),
                                  ),
                                );
                              },
                              child: Text(imageState.imageFile == null
                                  ? 'Photograph Medication'
                                  : 'Retake Picture'),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                submitPressed.value =
                                    true; // Set to true when the Submit button is pressed

                                if (formKey.currentState!.validate() &&
                                    imageState.imageFile != null) {
                                  final pill = Pill(
                                    id: 0, // id will get set by the server
                                    name: nameController.text,
                                    dosage: dosageController.text,
                                    manufacturer: manufacturerController.text,
                                  );
                                  pillsStateActions.postPill(pill);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
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
    );
  }
}
