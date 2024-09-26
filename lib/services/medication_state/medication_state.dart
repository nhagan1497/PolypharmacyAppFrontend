import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/medication/medication.dart';
import '../../models/pill/pill.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../repos/polypharmacy_repo.dart';
import '../../utilities/logger.dart';
import '../schedule_state/schedule_state.dart';

part 'medication_state.g.dart';
part 'medication_state.freezed.dart';

@freezed
class MedicationStateData with _$MedicationStateData {
  const factory MedicationStateData({
    Medication? selectedMedication,
    @Default([]) List<Medication> medicationList,
    @Default([]) List<PillSchedule> pillSchedules,
    @Default({}) Map<TimeOfDay, List<Medication>> medicationRounds,
    @Default([]) List<Pill> pills,
  }) = _MedicationStateData;
}

@riverpod
class MedicationState extends _$MedicationState {
  @override
  Future<MedicationStateData> build() async {
    final polyPharmacyRepo = await ref.read(polypharmacyRepoProvider.future);
    final results = await Future.wait([
      polyPharmacyRepo.getPillSchedules(null, 100),
      polyPharmacyRepo.getPills(),
    ], eagerError: true);

    final List<PillSchedule> pillSchedules = results[0] as List<PillSchedule>;
    final List<Pill> pills = results[1] as List<Pill>;

    final userMedications =
        _convertSchedulesToMedicationList(pillSchedules, pills);
    final userMedicationRounds =
        _convertSchedulesToMedicationRounds(pillSchedules, pills);

    return MedicationStateData(
        pillSchedules: pillSchedules,
        medicationList: userMedications,
        medicationRounds: userMedicationRounds,
        pills: pills);
  }

  void setSelectedMedication(Medication? medication) {
    final currentState = state.value!;
    final updatedState = currentState.copyWith(selectedMedication: medication);
    state = AsyncData(updatedState);
  }

  List<Medication> _convertSchedulesToMedicationList(
      List<PillSchedule> schedules, List<Pill> pills) {
    var groupedByPillId =
        groupBy(schedules, (PillSchedule schedule) => schedule.pillId);
    return groupedByPillId.entries.map((entry) {
      final pillSchedules = entry.value;
      final pillId = entry.key;
      Pill? matchingPill;

      try {
        matchingPill = pills.firstWhere((pill) => pill.id == pillId);
      } catch (e, s) {
        logger.e("Schedule had pill_id: $pillId but no matching pill was found",
            error: e, stackTrace: s);
      }

      return Medication(
        pillId: pillId,
        name: matchingPill!.name,
        dosage: matchingPill.dosage,
        schedules: pillSchedules,
      );
    }).toList();
  }

  Map<TimeOfDay, List<Medication>> _convertSchedulesToMedicationRounds(
      List<PillSchedule> schedules, List<Pill> pills) {
    var groupedByTime =
        groupBy(schedules, (PillSchedule schedule) => schedule.time);

    return groupedByTime.map((time, pillSchedules) {
      var groupedByPillId =
          groupBy(pillSchedules, (PillSchedule schedule) => schedule.pillId);

      var medications = groupedByPillId.entries.map((pillEntry) {
        final pillId = pillEntry.key;
        final schedulesForPill = pillEntry.value;

        Pill? matchingPill;
        try {
          matchingPill = pills.firstWhere((pill) => pill.id == pillId);
        } catch (e, s) {
          logger.e(
              "Schedule had pill_id: $pillId but no matching pill was found",
              error: e,
              stackTrace: s);
        }

        return Medication(
          pillId: pillId,
          name: matchingPill!.name,
          dosage: matchingPill.dosage,
          schedules: schedulesForPill,
        );
      }).toList();

      return MapEntry(time, medications);
    });
  }

  Future<void> deleteSchedulesForMedication(Medication medication) async {
    state = const AsyncLoading();
    try {
      final scheduleStateActions = ref.read(scheduleStateProvider.notifier);
      scheduleStateActions.sendPillScheduleDeleteRequests(medication.schedules);
    } catch (_) {}

    // Give the backend a second to delete the schedules before fetching again
    await Future.delayed(const Duration(seconds: 2));

    ref.invalidateSelf();
  }
}

List<TimeOfDay> getMedicationTimes(List<Medication> medications) {
  final Set<TimeOfDay> uniqueTimes = medications
      .expand(
          (medication) => medication.schedules.map((schedule) => schedule.time))
      .toSet();

  final List<TimeOfDay> sortedTimes = uniqueTimes.toList()
    ..sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });

  return sortedTimes;
}
