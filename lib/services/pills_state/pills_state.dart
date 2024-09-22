import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/pill/pill.dart';
import '../../repos/polypharmacy_repo.dart';
import '../../utilities/logger.dart';

part 'pills_state.g.dart';

@riverpod
class PillsState extends _$PillsState {
  @override
  Future<IList<Pill>> build() async {
    logger.d('Attempting to get pills');
    final polypharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final pills = await polypharmacyRepo.getPills();
    return pills.lock;
  }
}
