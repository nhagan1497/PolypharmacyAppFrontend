import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/ui/identification/identification_screen.dart';

import '../log/log_screen.dart';
import '../medication_list/medication_list_screen.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(2);

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

    return ProviderScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            screenTitles[currentIndex.value],
            style: const TextStyle(
              fontSize: 36,
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
              icon: Icon(Icons.medical_information),
              label: 'Med List',
            ),
          ],
        ),
      ),
    );
  }
}
