import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MedDialog extends HookWidget {
  const MedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final medNameController = useTextEditingController();
    final quantityController = useTextEditingController();
    final times = useState<List<TimeOfDay>>([]);

    Future<void> addTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && !times.value.contains(picked)) {
        times.value = [...times.value, picked];
      }
    }

    return AlertDialog(
      title: const Text('New Medication'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: medNameController,
              decoration: const InputDecoration(labelText: 'Medication Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            const Text('Times to Take:'),
            ...times.value.map((time) => Text(time.format(context))),
            TextButton(
              onPressed: addTime,
              child: const Text('Add Time'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            // Handle save logic here
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
