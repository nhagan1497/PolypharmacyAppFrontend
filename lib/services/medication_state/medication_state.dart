import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/medication/medication.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../repos/polypharmacy_repo.dart';

part 'medication_state.g.dart';
part 'medication_state.freezed.dart';

@freezed
class MedicationStateData with _$MedicationStateData {
  const factory MedicationStateData(
          {Medication? selectedMedication,
          @Default([]) List<Medication> medicationList,
          @Default([]) List<PillSchedule> pillSchedules,
          @Default({}) Map<TimeOfDay, List<Medication>> medicationRounds}) =
      _MedicationStateData;
}

@Riverpod(keepAlive: true)
class MedicationState extends _$MedicationState {
  @override
  Future<MedicationStateData> build() async {
    //final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    // final pillSchedules = await polyPharmacyRepo.getPillSchedules(null, 100);

    final userMedications = _convertSchedulesToMedicationList(pillSchedules);
    final userMedicationRounds =
        _convertSchedulesToMedicationRounds(pillSchedules);

    return MedicationStateData(
        pillSchedules: pillSchedules,
        medicationList: userMedications,
        medicationRounds: userMedicationRounds);
  }

  void alterSchedules(
    List<PillSchedule> schedulesToCreate,
    List<PillSchedule> schedulesToUpdate,
    List<PillSchedule> schedulesToDelete,
  ) {
    // final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    //
    // for (var scheduleToCreate in schedulesToCreate) {
    //   var result = polyPharmacyRepo.postPillSchedule(scheduleToCreate);
    // }
    //
    // for (var scheduleToUpdate in schedulesToUpdate) {
    //   var result = polyPharmacyRepo.putPillSchedule(scheduleToUpdate.id!);
    // }
    //
    // for (var scheduleToDelete in schedulesToDelete) {
    //   var result = polyPharmacyRepo.deletePillSchedule(scheduleToDelete.id!);
    // }
    //
    // ref.invalidateSelf();
  }

  void setSelectedMedication(Medication? medication) {
    final currentState = state.value!;
    final updatedState = currentState.copyWith(selectedMedication: medication);
    state = AsyncData(updatedState);
  }

  List<Medication> _convertSchedulesToMedicationList(
      List<PillSchedule> schedules) {
    var groupedByPillId =
        groupBy(schedules, (PillSchedule schedule) => schedule.pillId!);
    return groupedByPillId.entries.map((entry) {
      final pillSchedules = entry.value;
      final pillId = entry.key;

      return Medication(
        pillId: pillId,
        name: "Fix name", //pillSchedules.first.name,
        dosage: "Fix dosage", //pillSchedules.first.dosage,
        schedules: pillSchedules,
      );
    }).toList();
  }

  Map<TimeOfDay, List<Medication>> _convertSchedulesToMedicationRounds(
      List<PillSchedule> schedules) {
    // Group schedules by time
    var groupedByTime =
        groupBy(schedules, (PillSchedule schedule) => schedule.time);

    // Convert the grouped schedules into a map of time to list of Medication objects
    return groupedByTime.map((time, pillSchedules) {
      // Group the pill schedules by pillId to create Medication objects
      var groupedByPillId =
          groupBy(pillSchedules, (PillSchedule schedule) => schedule.pillId!);

      var medications = groupedByPillId.entries.map((pillEntry) {
        final pillId = pillEntry.key;
        final schedulesForPill = pillEntry.value;

        return Medication(
          pillId: pillId,
          name: "Fix name", //schedulesForPill.first.name,
          dosage: "Fix dosage", //,schedulesForPill.first.dosage,
          schedules: schedulesForPill,
        );
      }).toList();

      return MapEntry(time, medications);
    });
  }

  Future<void> deleteMedicationAndSchedules(Medication medication) async {
    // state = const AsyncLoading();
    // final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    // final deletePillResult = polyPharmacyRepo.deletePill(medication.pillId);
    //
    // final deleteScheduleFutures = medication.schedules.map((schedule) {
    //   return polyPharmacyRepo.deletePillSchedule(schedule.id!);
    // }).toList();
    //
    // await Future.wait([deletePillResult, ...deleteScheduleFutures]);
    // ref.invalidateSelf();
  }
}

List<Map<String, Object?>>? getMedicationsForTime(
  WidgetRef ref,
  DateTime time,
) {
  final medicationState = ref.watch(medicationStateProvider).valueOrNull;

  // Filter medications by the given time and map to include dosage and quantity
  final medicationsInRound = medicationState?.medicationList
      .where((medication) =>
          medication.schedules.any((schedule) => schedule.time == time))
      .expand((medication) => medication.schedules
          .where((schedule) => schedule.time == time)
          .map((schedule) => {
                'name': medication.name,
                'dosage': medication.dosage,
                'quantity': schedule.quantity
              }))
      .toList();

  return medicationsInRound;
}

List<TimeOfDay> getMedicationTimes(List<Medication> medications) {
  return medications
      .expand(
          (medication) => medication.schedules.map((schedule) => schedule.time))
      .toSet()
      .toList()
    ..sort((a, b) {
      // Convert TimeOfDay to minutes since midnight for comparison
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
}

List<PillSchedule> pillSchedules = [
  const PillSchedule(
    id: 0,
    pillId: 1,
    quantity: 1,
    time: TimeOfDay(hour: 7, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 1,
    quantity: 2,
    time: TimeOfDay(hour: 12, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 1,
    quantity: 3,
    time: TimeOfDay(hour: 20, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 2,
    quantity: 2,
    time: TimeOfDay(hour: 12, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 3,
    quantity: 3,
    time: TimeOfDay(hour: 7, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 3,
    quantity: 3,
    time: TimeOfDay(hour: 20, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 4,
    quantity: 2,
    time: TimeOfDay(hour: 20, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 5,
    quantity: 1,
    time: TimeOfDay(hour: 7, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 5,
    quantity: 1,
    time: TimeOfDay(hour: 12, minute: 0),
  ),
  const PillSchedule(
    id: 0,
    pillId: 5,
    quantity: 2,
    time: TimeOfDay(hour: 20, minute: 0),
  ),
];
