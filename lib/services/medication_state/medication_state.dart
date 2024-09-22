import 'package:collection/collection.dart';
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
          @Default({}) Map<DateTime, List<Medication>> medicationRounds}) =
      _MedicationStateData;
}

@riverpod
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
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;

    for (var scheduleToCreate in schedulesToCreate) {
      var result = polyPharmacyRepo.postPillSchedule(scheduleToCreate);
    }

    for (var scheduleToUpdate in schedulesToUpdate) {
      var result = polyPharmacyRepo.putPillSchedule(scheduleToUpdate.id!);
    }

    for (var scheduleToDelete in schedulesToDelete) {
      var result = polyPharmacyRepo.deletePillSchedule(scheduleToDelete.id!);
    }

    ref.invalidateSelf();
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
        name: pillSchedules.first.name,
        dosage: pillSchedules.first.dosage,
        schedules: pillSchedules,
      );
    }).toList();
  }

  Map<DateTime, List<Medication>> _convertSchedulesToMedicationRounds(
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
          name: schedulesForPill.first.name,
          dosage: schedulesForPill.first.dosage,
          schedules: schedulesForPill,
        );
      }).toList();

      return MapEntry(time, medications);
    });
  }

  Future<void> deleteMedicationAndSchedules(Medication medication) async {
    state = const AsyncLoading();
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final deletePillResult = polyPharmacyRepo.deletePill(medication.pillId);

    final deleteScheduleFutures = medication.schedules.map((schedule) {
      return polyPharmacyRepo.deletePillSchedule(schedule.id!);
    }).toList();

    await Future.wait([deletePillResult, ...deleteScheduleFutures]);
    ref.invalidateSelf();
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

List<DateTime> getMedicationTimes(List<Medication> medications) {
  return medications
      .expand(
          (medication) => medication.schedules.map((schedule) => schedule.time))
      .toSet()
      .toList()
    ..sort((a, b) => a.compareTo(b));
}

List<PillSchedule> pillSchedules = [
  PillSchedule(
    name: 'Aspirin',
    dosage: '100mg',
    pillId: 1,
    quantity: 1,
    time: DateTime(1970, 1, 1, 7, 0),
    userId: 101,
    id: 1,
  ),
  PillSchedule(
    name: 'Aspirin',
    dosage: '100mg',
    pillId: 1,
    quantity: 2,
    time: DateTime(1970, 1, 1, 12, 0),
    userId: 101,
    id: 1,
  ),
  PillSchedule(
    name: 'Aspirin',
    dosage: '100mg',
    pillId: 1,
    quantity: 3,
    time: DateTime(1970, 1, 1, 20, 0),
    userId: 101,
    id: 1,
  ),
  PillSchedule(
    name: 'Ibuprofen',
    dosage: '200mg',
    pillId: 2,
    quantity: 2,
    time: DateTime(1970, 1, 1, 12, 0),
    userId: 102,
    id: 2,
  ),
  PillSchedule(
    name: 'Paracetamol',
    dosage: '500mg',
    pillId: 3,
    quantity: 3,
    time: DateTime(1970, 1, 1, 7, 0),
    userId: 103,
    id: 3,
  ),
  PillSchedule(
    name: 'Paracetamol',
    dosage: '500mg',
    pillId: 3,
    quantity: 3,
    time: DateTime(1970, 1, 1, 20, 0),
    userId: 103,
    id: 3,
  ),
  PillSchedule(
    name: 'Prozac',
    dosage: '25mg',
    pillId: 4,
    quantity: 2,
    time: DateTime(1970, 1, 1, 20, 0),
    userId: 105,
    id: 5,
  ),
  PillSchedule(
    name: 'Amoxicillin',
    dosage: '250mg',
    pillId: 5,
    quantity: 1,
    time: DateTime(1970, 1, 1, 7, 0),
    userId: 105,
    id: 5,
  ),
  PillSchedule(
    name: 'Amoxicillin',
    dosage: '250mg',
    pillId: 5,
    quantity: 1,
    time: DateTime(1970, 1, 1, 12, 0),
    userId: 105,
    id: 5,
  ),
  PillSchedule(
    name: 'Amoxicillin',
    dosage: '250mg',
    pillId: 5,
    quantity: 2,
    time: DateTime(1970, 1, 1, 20, 0),
    userId: 105,
    id: 5,
  ),
];
