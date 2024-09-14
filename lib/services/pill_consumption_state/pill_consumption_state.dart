import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:polypharmacy/models/pill_consumption/pill_consumption.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repos/polypharmacy_repo.dart';

part 'pill_consumption_state.g.dart';
part 'pill_consumption_state.freezed.dart';

@freezed
class PillConsumptionStateData with _$PillConsumptionStateData {
  const factory PillConsumptionStateData(
          {@Default([]) List<PillConsumption> pillConsumptions}) =
      _PillConsumptionStateData;
}

@riverpod
class PillConsumptionState extends _$PillConsumptionState {
  @override
  Future<PillConsumptionStateData> build() async {
    final polyPharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    final pillConsumptions = await polyPharmacyRepo.getPillConsumptions();
    return PillConsumptionStateData(pillConsumptions: pillConsumptions);
  }
}
