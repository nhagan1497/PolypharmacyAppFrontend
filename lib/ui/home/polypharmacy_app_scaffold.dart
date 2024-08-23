import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/ui/identification/identification_screen.dart';
import 'package:polypharmacy/ui/login/blue_box_decoration.dart';

import '../log/log_screen.dart';
import '../medication_list/medication_list_screen.dart';
import 'home_screen.dart';

class PolypharmacyAppScaffold extends HookWidget {
  const PolypharmacyAppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    final List<Widget> screens = [
      const HomeScreen(),
      const LogScreen(),
      const MedicationListScreen(),
      const IdentificationScreen(),
      const ProfileScreen(),
    ];

    final List<String> screenTitles = [
      'Home',
      'Schedule',
      'Medications',
      'Identify Medication',
      'Settings'
    ];

    return Scaffold(
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Identify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
