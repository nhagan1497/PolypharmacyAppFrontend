import 'package:polypharmacy/models/pill_consumption/pill_consumption.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../repos/polypharmacy_repo.dart';

part 'pill_count_state.g.dart';

@riverpod
class PillCountState extends _$PillCountState {
  @override
  Future<int> build(int pillId) async {
    final polyPharmacyRepo = await ref.watch(polypharmacyRepoProvider.future);
    final pillCount =
        await polyPharmacyRepo.getRemainingPillCount(pillId: pillId);
    final count =
        pillCount.remainingPillCount < 0 ? 0 : pillCount.remainingPillCount;
    return count;
  }

  Future<void> updatePillCount(int pillId, int count) async {
    final currentCount = state.value;
    state = const AsyncLoading();
    final polyPharmacyRepo = await ref.watch(polypharmacyRepoProvider.future);
    final refillPillConsumption =
        PillConsumption(pillId: pillId, quantity: -count, time: DateTime.now());
    try {
      await polyPharmacyRepo.postPillConsumption(
          contentType: "application/json",
          pillConsumption: refillPillConsumption);
    } finally {
      state = AsyncData(count + currentCount!);
    }
  }
}
