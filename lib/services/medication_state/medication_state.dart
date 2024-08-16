import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/medication/medication.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../repos/polypharmacy_repo.dart';

part 'medication_state.g.dart';

@riverpod
class MedicationState extends _$MedicationState {
  @override
  Future<IList<Medication>> build() async{
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final pillSchedules = await polyPharmacyRepo.getPillSchedules();
    final userMedications = convertSchedulesToMedicationList(pillSchedules);
    return userMedications.lock;
  }

  List<Medication> convertSchedulesToMedicationList(List<PillSchedule> schedules) {
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
}
