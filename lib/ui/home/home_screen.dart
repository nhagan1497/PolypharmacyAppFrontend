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

    return Scaffold(
      body: RefreshIndicator(
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
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 200),
                                  Icon(
                                    Symbols.pill,
                                    size: 80, // Adjust icon size as needed
                                    color: Colors.blue, // Customize color
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
                          ]
                        : [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${getGreeting()}, ${FirebaseAuth.instance.currentUser?.displayName?.split(" ").first}!",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "You have ${getMedicationTimes(value.medicationList).length} rounds of medication today.",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            for (var ingestionTime
                                in getMedicationTimes(value.medicationList))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: MedicationRound(
                                    time: ingestionTime, date: DateTime.now()),
                              ),
                          ],
                    AsyncError() => [
                        const SizedBox(height: 200),
                        const Center(
                          child: CustomErrorWidget(
                            errorMessage:
                                "An error occurred while fetching medications. Please try again later.",
                          ),
                        ),
                      ],
                    _ =>
                      <Widget>[], // Ensure we return an empty list of widgets
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
