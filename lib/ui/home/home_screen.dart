import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:polypharmacy/ui/identification/identification_screen.dart';

import '../log/log_screen.dart';
import '../medication_list/medication_list_screen.dart';
import '../medication_list/medication_screen.dart'; // Import your MedicationScreen

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    final List<Widget> screens = [
      const LogScreen(),
      const IdentificationScreen(),
      const MedicationListScreen(),
    ];

    final List<String> screenTitles = [
      'Medication Log',
      'Identify Medication',
      'Medication List',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            screenTitles[currentIndex.value],
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: currentIndex.value,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) {
          if (currentIndex.value != index) {
            currentIndex.value = index;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Identify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_rounded),
            label: 'Med List',
          ),
        ],
      ),
      floatingActionButton: currentIndex.value == 2
          ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MedicationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
