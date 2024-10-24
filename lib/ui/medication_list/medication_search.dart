import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/medication/medication.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/pills_state/pills_state.dart';
import '../../utilities/custom_error_widget.dart';
import 'medication_create_screen.dart';

class MedicationSearch extends HookConsumerWidget {
  const MedicationSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillsState = ref.watch(pillsStateProvider);
    final currentlySelectedMedication =
        ref.watch(medicationStateProvider).value!.selectedMedication;
    final medicationStateActions = ref.watch(medicationStateProvider.notifier);

    // useState for managing search query state
    final searchQuery = useState(currentlySelectedMedication?.name ?? '');

    // TextEditingController to control and update the search bar input
    final searchController = useTextEditingController(text: searchQuery.value);

    useEffect(() {
      searchController.text =
          searchQuery.value; // Sync search bar with searchQuery
      return;
    }, [searchQuery.value]);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensure the column takes minimum space needed
        children: [
          // Search Bar
          SearchBar(
            hintText: 'Search medication',
            controller:
                searchController, // Use the controller for two-way binding
            onChanged: (value) {
              searchQuery.value =
                  value; // Update the search query as the user types
            },
            leading: const Icon(Icons.search),
          ),

          if (searchQuery.value.isNotEmpty &&
              currentlySelectedMedication == null)
            pillsState.when(
              data: (pills) {
                final filteredPills = pills
                    .where((pill) => pill.name
                        .toLowerCase()
                        .contains(searchQuery.value.toLowerCase()))
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling inside the ListView
                    children: [
                      ...filteredPills.map((pill) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text("${pill.name} - ${pill.dosage}"),
                              onTap: () {
                                // Update the selected medication
                                medicationStateActions.setSelectedMedication(
                                  Medication(
                                    name: pill.name,
                                    dosage: pill.dosage,
                                    manufacturer: pill.manufacturer,
                                    pillId: pill.id,
                                    schedules: [],
                                  ),
                                );
                                searchQuery.value = pill.name;
                                searchController.text = pill.name;
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          )),
                      if (filteredPills.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No matches found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MedicationCreateScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create New Medication'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Column(
                children: [
                  SizedBox(height: 16),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
              error: (error, _) => const Column(
                children: [
                  SizedBox(height: 16),
                  CustomErrorWidget(
                      errorMessage:
                          "An error occurred while trying to get global medication list. Please try again later."),
                ],
              ),
            )
        ],
      ),
    );
  }
}
