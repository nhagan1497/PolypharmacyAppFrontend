import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polypharmacy/ui/medication_list/schedule_dialog.dart';
import '../../models/medication/medication.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../services/schedule_state/dart/schedule_state/schedule_state.dart';
import '../login/blue_box_decoration.dart';

class MedicationScreen extends HookConsumerWidget {
  final Medication? medication;
  const MedicationScreen({super.key, this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medNameController = useTextEditingController(text: medication?.name ?? '');
    final scheduleState = ref.watch(scheduleStateProvider);
    final scheduleStateActions = ref.watch(scheduleStateProvider.notifier);

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                elevation: 5.0, // Adjust the elevation to control the shadow depth
                shadowColor: Colors.grey, // Set the shadow color
                borderRadius: BorderRadius.circular(8.0), // Optional: Set border radius
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Set the same border radius here
                  child: TextField(
                    controller: medNameController,
                    decoration: InputDecoration(
                      labelText: 'Medication Name',
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (scheduleState.schedules.isNotEmpty)
                        DataTable(
                          columnSpacing: 32,
                          headingRowHeight: 32.0,
                          dataRowHeight: 40.0,
                          columns: const [
                            DataColumn(label: Center(child: Text('Time'))),
                            DataColumn(label: Center(child: Text('Quantity'))),
                            DataColumn(label: Center(child: Text('    Edit/Delete'))),
                          ],
                          rows: scheduleState.schedules.asMap().entries.map((entry) {
                            int index = entry.key;
                            PillSchedule schedule = entry.value;

                            return DataRow(cells: [
                              DataCell(Center(child: Text(TimeOfDay.fromDateTime(schedule.time).format(context)))),
                              DataCell(Center(child: Text(schedule.quantity.toString()))),
                              DataCell(
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ScheduleDialog(index: index);
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          scheduleStateActions.addScheduleToDelete(index);
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
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ScheduleDialog(index: null);
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Schedule'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement save medication logic
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
    );
  }
}
