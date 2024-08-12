import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/user_medication/user_medication.dart';
import '../../repos/polypharmacy_repo.dart';

part 'med_list_state.g.dart';

@riverpod
class MedListState extends _$MedListState {
  @override
  Future<IList<UserMedication>> build() async{
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final pillSchedules = await polyPharmacyRepo.getPillSchedules();
    var tempList =  [const UserMedication(quantity: 1, name: "test", timesOfDay: ["12:00"])];
    return tempList.lock;
  }
}