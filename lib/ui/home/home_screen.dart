import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:polypharmacy/ui/home/medication_round.dart';
import 'package:polypharmacy/services/medication_state/medication_state.dart';
import 'package:polypharmacy/utilities/custom_error_widget.dart';
import '../../services/pill_consumption_state/pill_consumption_state.dart';
import '../../utilities/time_helpers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationState = ref.watch(medicationStateProvider);

    return DefaultTabController(
      length: 2,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(medicationStateProvider.future),
            ref.refresh(pillConsumptionStateProvider.future),
          ], eagerError: true);
        },
        child: Stack(
          children: [
            // Main content
            Positioned.fill(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ...switch (medicationState) {
                    AsyncData(:final value) => value.medicationList.isEmpty
                        ? [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: const Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Symbols.pill,
                                    size: 80,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Add some prescriptions to your account to start logging your medication intake.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                        : [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${getGreeting()}, ${FirebaseAuth.instance.currentUser?.displayName?.split(" ").first}!",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "You have ${getMedicationTimes(value.medicationList).length} rounds of medication today.",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            // Tab bar for selecting between "Log" and "Adherence"
                            TabBar(
                              labelColor: Theme.of(context).primaryColor,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Theme.of(context).primaryColor,
                              tabs: const [
                                Tab(text: "Log"),
                                Tab(text: "Adherence"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Tab view content for "Log" and "Adherence"
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 300, // Adjust height as needed
                        child: TabBarView(
                          children: [
                            // Log Tab Content (Medication Rounds)
                            ListView(
                              children: [
                                for (var ingestionTime in getMedicationTimes(value.medicationList))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: MedicationRound(
                                      time: ingestionTime,
                                      date: DateTime.now(),
                                    ),
                                  ),
                              ],
                            ),
                            // Adherence Tab Content (Placeholder)
                            const Center(
                              child: Text("Adherence Placeholder"),
                            ),
                          ],
                        ),
                      ),
                    ],
                    AsyncError() => [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: const Center(
                          child: CustomErrorWidget(
                            errorMessage: "An error occurred while fetching medications. Please try again later.",
                          ),
                        ),
                      ),
                    ],
                    _ => <Widget>[], // Ensure we return an empty list of widgets
                  } as Iterable<Widget>, // Ensure we cast to Iterable<Widget>
                ],
              ),
            ),
            // Center the CircularProgressIndicator
            if (medicationState is AsyncLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
