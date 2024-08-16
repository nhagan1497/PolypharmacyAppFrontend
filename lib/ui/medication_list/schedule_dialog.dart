import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/medication/medication.dart';
import '../../services/schedule_state/dart/schedule_state/schedule_state.dart';

class ScheduleDialog extends HookConsumerWidget {
  final Medication? medication;
  final int? index;
  const ScheduleDialog({super.key, this.medication, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleStateProvider);
    final scheduleStateActions = ref.watch(scheduleStateProvider.notifier);
    final quantityController = TextEditingController();
    final showError = useState<String?>(null);
    TimeOfDay? selectedTime;

    if (index != null) {
      quantityController.text = scheduleState.schedules[index!].quantity.toString();
      final time = scheduleState.schedules[index!].time;
      selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
    }

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
                selectedTime = picked;
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
              showError.value = 'Please enter a valid quantity.';
            } else if (selectedTime == null) {
              showError.value = 'Please select a valid time.';
            } else {
              if (index == null) {
                scheduleStateActions.addScheduleToCreate(quantity, selectedTime!);
              } else {
                scheduleStateActions.addScheduleToUpdate(index!, quantity, selectedTime!);
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
