import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:polypharmacy/models/pill_consumption/pill_consumption.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repos/polypharmacy_repo.dart';
import '../../utilities/notification_service.dart';
import '../pill_count_state/dart/pill_count_state.dart';

part 'pill_consumption_state.g.dart';

@riverpod
class PillConsumptionState extends _$PillConsumptionState {
  @override
  Future<IList<PillConsumption>> build() async {
    final polyPharmacyRepo = await ref.watch(polypharmacyRepoProvider.future);
    final pillConsumptions =
        await polyPharmacyRepo.getPillConsumptions(0, 1000);
    return pillConsumptions.lock;
  }

  Future<void> addPillConsumption(PillConsumption pillConsumption) async {
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    state = AsyncData(state.value!.add(pillConsumption));

    final pillConsumptionWithId = await polyPharmacyRepo.postPillConsumption(
        contentType: "application/json", pillConsumption: pillConsumption);

    final previousState = await future;
    state = AsyncData(
        previousState.remove(pillConsumption).add(pillConsumptionWithId));

    // Get pill count to check if a low pill count notification should be sent
    final pillCount = await ref.read(pillCountStateProvider(pillConsumption.pillId).future);
    if (pillCount <= 5) {
      NotificationService.showNotification(id: 1, title: "Low Pill Alert", body: "You are low on medication. Check and update your pill quantity on the Medicine page.");
    }
  }

  Future<void> deletePillConsumption(PillConsumption pillConsumption) async {
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    state = AsyncData(state.value!.remove(pillConsumption));
    await polyPharmacyRepo.deletePillConsumption(
        pillConsumptionId: pillConsumption.id!);
  }
}
