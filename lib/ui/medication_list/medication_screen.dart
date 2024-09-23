import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polypharmacy/ui/medication_list/schedule_dialog.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../services/medication_state/medication_state.dart';
import '../../services/schedule_state/schedule_state.dart';
import '../../utilities/custom_loading_widget.dart';
import '../login/blue_box_decoration.dart';
import 'medication_search.dart';

class MedicationScreen extends HookConsumerWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentlySelectedMedication =
        ref.watch(medicationStateProvider).value!.selectedMedication;
    final medicationStateActions = ref.watch(medicationStateProvider.notifier);
    final scheduleState = ref.watch(scheduleStateProvider);
    final scheduleStateActions = ref.watch(scheduleStateProvider.notifier);

    // Pop the screen if schedules were successfully updated
    useEffect(() {
      if (scheduleState.value?.successfullyUpdatedSchedules == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
      return null;
    }, [scheduleState]);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: blueBoxDecoration,
        ),
        centerTitle: true,
        title: const Text(
          "Medication",
          style: TextStyle(
            fontSize: 36,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: scheduleState.isLoading
            ? const Center(
                child:
                    CustomLoadingWidget(loadingMessage: "Saving Schedules..."),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (currentlySelectedMedication != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              medicationStateActions
                                  .setSelectedMedication(null);
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Search for New Medication'),
                          ),
                        ),
                      ),
                    currentlySelectedMedication == null
                        ? const MedicationSearch()
                        : Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "${currentlySelectedMedication.name} - ${currentlySelectedMedication.dosage}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (scheduleState.value!.schedules.isNotEmpty)
                                    DataTable(
                                      columnSpacing: 32,
                                      headingRowHeight: 32.0,
                                      dataRowHeight: 40.0,
                                      columns: const [
                                        DataColumn(
                                            label: Center(child: Text('Time'))),
                                        DataColumn(
                                            label: Center(
                                                child: Text('Quantity'))),
                                        DataColumn(
                                            label: Center(
                                                child:
                                                    Text('    Edit/Delete'))),
                                      ],
                                      rows: scheduleState.value!.schedules
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        PillSchedule schedule = entry.value;

                                        return DataRow(cells: [
                                          DataCell(Center(
                                              child: Text(schedule.time
                                                  .format(context)))),
                                          DataCell(Center(
                                              child: Text(schedule.quantity
                                                  .toString()))),
                                          DataCell(
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ScheduleDialog(
                                                              index: index);
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () {
                                                      scheduleStateActions
                                                          .addScheduleToDelete(
                                                              schedule);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]);
                                      }).toList(),
                                    )
                                  else
                                    const Center(
                                      child: Text(
                                        "No times have been scheduled.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ScheduleDialog(
                                                index: null);
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Schedule'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        scheduleStateActions
                                            .sendScheduleRequests();
                                      },
                                      icon: const Icon(Icons.save),
                                      label: const Text('Save Medication'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
