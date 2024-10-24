import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_count_state.g.dart';

@Riverpod(keepAlive: true)
class PillCountState extends _$PillCountState {
  @override
  Future<int> build(int pillId) async {
    // final polyPharmacyRepo = await ref.watch(polypharmacyRepoProvider.future);
    // final pillConsumptions =
    // await polyPharmacyRepo.getPillConsumptions(0, 1000);
    await Future.delayed(const Duration(seconds: 2));
    const count = 7;
    return count;
  }

  Future<void> updatePillCount(int pillId, int count) async {
    // final polyPharmacyRepo = await ref.watch(polypharmacyRepoProvider.future);
    // await polyPharmacyRepo.updatePillCount(pillId, count);
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    state = AsyncData(count);
  }
}
