import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/ui/identification/identification_screen.dart';
import 'package:polypharmacy/ui/login/blue_box_decoration.dart';

import '../log/log_screen.dart';
import '../medication_list/medication_list_screen.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(1);

    final List<Widget> screens = [
      const LogScreen(),
      const MedicationListScreen(),
      const IdentificationScreen(),
      const ProfileScreen(),
    ];

    final List<String> screenTitles = [
      'Medication Log',
      'Medication List',
      'Identify Medication',
      'Settings'
    ];

    return ProviderScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: blueBoxDecoration,
          ),
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
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex.value,
          onTap: (index) {
            if (currentIndex.value != index) {
              currentIndex.value = index;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_information),
              label: 'Med List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Identify',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
