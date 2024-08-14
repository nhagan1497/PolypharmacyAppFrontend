import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/pill_schedule/pill_schedule.dart';
import '../../models/user_medication/user_medication.dart';
import '../../repos/polypharmacy_repo.dart';

part 'med_list_state.g.dart';

@riverpod
class MedListState extends _$MedListState {
  @override
  Future<IList<UserMedication>> build() async{
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final pillSchedules = await polyPharmacyRepo.getPillSchedules();
    final userMedications = aggregatePillSchedules(pillSchedules);
    return userMedications.lock;
  }

  List<UserMedication> aggregatePillSchedules(List<PillSchedule> schedules) {
    var groupedByPillId = groupBy(schedules, (PillSchedule schedule) => schedule.pillId);
    return groupedByPillId.entries.map((entry) {
      var pillSchedules = entry.value;
      var firstSchedule = pillSchedules.first;
      var administrations = <String, int>{};

      for (var schedule in pillSchedules) {
        var time = DateFormat.jm().format(schedule.time);
        administrations[time] = schedule.quantity ?? 0;
      }

      return UserMedication(
        name: firstSchedule.name,
        dosage: firstSchedule.dosage,
        dailyAdministrations: administrations,
      );
    }).toList();
  }
}
