import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/ui/identification/identification_screen.dart';
import 'package:polypharmacy/ui/login/blue_box_decoration.dart';

import 'ui/calendar/calendar_screen.dart';
import 'ui/medication_list/medication_list_screen.dart';
import 'ui/home/home_screen.dart';

class PolypharmacyAppScaffold extends HookWidget {
  const PolypharmacyAppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final PageStorageBucket bucket = PageStorageBucket();

    // List of screens
    final List<Widget> screens = [
      const HomeScreen(key: PageStorageKey('HomeScreen')),
      const CalendarScreen(key: PageStorageKey('CalendarScreen')),
      const IdentificationScreen(key: PageStorageKey('IdentificationScreen')),
      const MedicationListScreen(key: PageStorageKey('MedicationListScreen')),
      const ProfileScreen(key: PageStorageKey('ProfileScreen')),
    ];

    final List<String> screenTitles = [
      'Home',
      'Schedule',
      'Single Pill ID',
      'Medications',
      'Settings',
    ];

    // Helper function to build the selected screen
    Widget buildScreen(int index) {
      return PageStorage(
        bucket: bucket,
        child: screens[index],
      );
    }

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
      // Display only the currently selected screen
      body: SafeArea(child: buildScreen(currentIndex.value)),
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
            icon: Icon(Symbols.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.search_check_2),
            label: 'Pill ID',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.prescriptions),
            label: 'Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.settings_account_box),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
