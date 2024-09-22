import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:polypharmacy/models/pill_consumption/pill_consumption.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repos/polypharmacy_repo.dart';

part 'pill_consumption_state.g.dart';

@riverpod
class PillConsumptionState extends _$PillConsumptionState {
  @override
  Future<IList<PillConsumption>> build() async {
    // final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    // final pillConsumptions = await polyPharmacyRepo.getPillConsumptions();

    final today7AM = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      7, // 7:00 AM
      0, // Minutes
      0, // Seconds
    );

    final today12PM = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      12, // 12:00 AM
      0, // Minutes
      0, // Seconds
    );

    final pill1 = PillConsumption(
      pillId: 1,
      quantity: 1,
      time: today7AM,
      id: 1,
    );

    final pill2 = PillConsumption(
      pillId: 2,
      quantity: 2,
      time: today12PM,
      id: 2,
    );

    final pill3 = PillConsumption(
      pillId: 3,
      quantity: 1,
      time: today7AM,
      id: 3,
    );

    return [pill1, pill2, pill3].lock;
  }

  Future<void> addPillConsumption(PillConsumption pillConsumption) async {
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    state = AsyncData(state.value!.add(pillConsumption));

    final pillConsumptionWithId =
        await polyPharmacyRepo.postPillConsumption(pillConsumption);

    final previousState = await future;
    state = AsyncData(
        previousState.remove(pillConsumption).add(pillConsumptionWithId));
  }

  Future<void> deletePillConsumption(PillConsumption pillConsumption) async {
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    state = AsyncData(state.value!.remove(pillConsumption));
    await polyPharmacyRepo.deletePillConsumption(pillConsumption.id!);
  }
}
