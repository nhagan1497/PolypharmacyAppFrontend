import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:polypharmacy/ui/identification/identification_screen.dart';

import '../log/log_screen.dart';
import '../schedule/schedule_screen.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    final List<Widget> screens = [
      LogScreen(),
      IdentificationScreen(),
      ScheduleScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) {
          currentIndex.value = index;
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
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}