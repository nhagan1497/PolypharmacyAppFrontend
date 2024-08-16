import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MedicationScreen extends HookWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medNameController = useTextEditingController();
    final scheduleList = useState<List<Map<String, dynamic>>>([]);
    final showError = useState<String?>(null);

    void addSchedule(String quantity, TimeOfDay time) {
      scheduleList.value = [
        ...scheduleList.value,
        {'quantity': quantity, 'time': time},
      ];
    }

    Future<void> showAddScheduleDialog() async {
      final quantityController = TextEditingController();
      TimeOfDay? selectedTime;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Medication Administration'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: const Text('Select Time'),
                    ),
                    const SizedBox(height: 10),
                    if (selectedTime != null)
                      Text('Selected Time: ${selectedTime!.format(context)}'),
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
                    child: const Text('Add'),
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
                        addSchedule(quantity, selectedTime!);
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
                decoration: const InputDecoration(labelText: 'Medication Name'),
              ),

              const SizedBox(height: 20),
                Center(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Time')),
                    ],
                    rows: scheduleList.value.map((schedule) {
                      return DataRow(cells: [
                        DataCell(Text(schedule['quantity'])),
                        DataCell(Text(schedule['time'].format(context))),
                      ]);
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: showAddScheduleDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Administration'),
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
