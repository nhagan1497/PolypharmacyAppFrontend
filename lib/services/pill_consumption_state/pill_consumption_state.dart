import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
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

    const today7AM = TimeOfDay(
      hour: 7, // 12:00 AM
      minute: 0, // Minutes
    );


    const today12PM = TimeOfDay(
      hour: 12, // 12:00 AM
      minute: 0, // Minutes
    );

    const pill1 = PillConsumption(
      pillId: 1,
      quantity: 1,
      time: today7AM,
      id: 1,
    );

    const pill2 = PillConsumption(
      pillId: 2,
      quantity: 2,
      time: today12PM,
      id: 2,
    );

    const pill3 = PillConsumption(
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
