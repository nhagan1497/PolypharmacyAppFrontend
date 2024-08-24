import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/medication/medication.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../repos/polypharmacy_repo.dart';

part 'medication_state.g.dart';
part 'medication_state.freezed.dart';

@freezed
class MedicationStateData with _$MedicationStateData {
  const factory MedicationStateData({
    Medication? selectedMedication,
    @Default([]) List<Medication> medicationList,
  }) = _MedicationStateData;
}

@riverpod
class MedicationState extends _$MedicationState {
  @override
  Future<MedicationStateData> build() async{
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final pillSchedules = await polyPharmacyRepo.getPillSchedules();
    final userMedications = _convertSchedulesToMedicationList(pillSchedules);
    return MedicationStateData(medicationList: userMedications);
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
    state = state.whenData((data) => data.copyWith(selectedMedication: medication));
  }

  List<Medication> _convertSchedulesToMedicationList(List<PillSchedule> schedules) {
    var groupedByPillId = groupBy(schedules, (PillSchedule schedule) => schedule.pillId!);
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
