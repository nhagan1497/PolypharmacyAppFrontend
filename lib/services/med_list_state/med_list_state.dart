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
      return UserMedication(
        name: firstSchedule.name,
        dosage: firstSchedule.dosage,
        quantity: firstSchedule.quantity ?? 0,
        timesOfDay: pillSchedules.map((schedule) {
          var time = schedule.time;
          return DateFormat.jm().format(time); // Format time as "10:00AM"
        }).toList(),
      );
    }).toList();
  }
}
