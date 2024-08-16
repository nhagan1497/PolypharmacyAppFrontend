import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/medication/medication.dart';

class MedicationScreen extends HookWidget {
  final Medication? medication;
  const MedicationScreen({super.key, this.medication});

  @override
  Widget build(BuildContext context) {
    final medNameController = useTextEditingController(text: medication?.name ?? '');

    final scheduleList = useState<List<Map<String, dynamic>>>(
      medication?.schedules.map((schedule) => {
        'quantity': schedule.quantity.toString(),
        'time': TimeOfDay.fromDateTime(schedule.time) // Assuming time is a TimeOfDay object
      }).toList() ?? [],
    );
    final showError = useState<String?>(null);

    void addSchedule(String quantity, TimeOfDay time) {
      scheduleList.value = [
        ...scheduleList.value,
        {'quantity': quantity, 'time': time},
      ];
    }

    void editSchedule(int index, String quantity, TimeOfDay time) {
      scheduleList.value = [
        ...scheduleList.value.sublist(0, index),
        {'quantity': quantity, 'time': time},
        ...scheduleList.value.sublist(index + 1),
      ];
    }

    void deleteSchedule(int index) {
      scheduleList.value = [
        ...scheduleList.value.sublist(0, index),
        ...scheduleList.value.sublist(index + 1),
      ];
    }

    Future<void> showAddScheduleDialog({int? index}) async {
      final quantityController = TextEditingController();
      TimeOfDay? selectedTime;

      if (index != null) {
        quantityController.text = scheduleList.value[index]['quantity'];
        selectedTime = scheduleList.value[index]['time'];
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Center(child: Text(index == null ? 'Add Schedule' : 'Edit Schedule')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    if (selectedTime != null)
                      Text('Selected Time: ${selectedTime!.format(context)}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? const TimeOfDay(hour: 0, minute: 0),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: const Text('Select Time'),
                    ),
                    if (showError.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          showError.value!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(index == null ? 'Add' : 'Update'),
                    onPressed: () {
                      final quantity = quantityController.text;
                      if (quantity.isEmpty || int.tryParse(quantity) == null || int.parse(quantity) <= 0) {
                        setState(() {
                          showError.value = 'Please enter a valid quantity.';
                        });
                      } else if (selectedTime == null) {
                        setState(() {
                          showError.value = 'Please select a valid time.';
                        });
                      } else {
                        if (index == null) {
                          addSchedule(quantity, selectedTime!);
                        } else {
                          editSchedule(index, quantity, selectedTime!);
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Medication",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle save logic here
              Navigator.of(context).pop();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: medNameController,
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              if (scheduleList.value.isNotEmpty)
              Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return DataTable(
                      columnSpacing: 32, // Adjust based on total number of columns
                      headingRowHeight: 32.0, // Consistent height for the header row
                      dataRowHeight: 40.0, // Consistent height for the data rows
                      columns: const [
                        DataColumn(label: Expanded(child: Center(child: Text('Time')))),
                        DataColumn(label: Expanded(child: Center(child: Text('Quantity')))),
                        DataColumn(label: Expanded(child: Center(child: Text('Edit/Delete')))),
                      ],
                      rows: scheduleList.value.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> schedule = entry.value;
                        return DataRow(cells: [
                          DataCell(Expanded(child: Center(child: Text(schedule['time'].format(context))))),
                          DataCell(Expanded(child: Center(child: Text(schedule['quantity'])))),
                          DataCell(
                            Expanded(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showAddScheduleDialog(index: index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        deleteSchedule(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: showAddScheduleDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Schedule'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: showAddScheduleDialog,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Medication'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
