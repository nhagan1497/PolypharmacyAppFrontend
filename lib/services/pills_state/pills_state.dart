import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/medication/medication.dart';
import '../../models/pill/pill.dart';
import '../../repos/polypharmacy_repo.dart';
import '../image_state/image_state.dart';
import '../medication_state/medication_state.dart';

part 'pills_state.g.dart';

@riverpod
class PillsState extends _$PillsState {
  @override
  Future<IList<Pill>> build() async {
    final polypharmacyRepo = await ref.read(polypharmacyRepoProvider.future);
    final pills = await polypharmacyRepo.getPills();
    return pills.lock;
  }

  Future<void> postPill(Pill pill) async {
    state = const AsyncLoading();
    try {
      final polypharmacyRepo = ref.read(polypharmacyRepoProvider).value!;
      final medicationStateActions = ref.read(medicationStateProvider.notifier);
      final imageState = ref.read(imageStateProvider);

      final newPill = await polypharmacyRepo.postPill(
        name: pill.name,
        dosage: pill.dosage,
        manufacturer: pill.manufacturer,
        image: imageState.imageFile!,
      );

      medicationStateActions.setSelectedMedication(Medication(
        name: newPill.name,
        dosage: newPill.dosage,
        manufacturer: newPill.manufacturer,
        pillId: newPill.id,
        schedules: [],
      ));
    } catch (e, s) {
      state = AsyncError(e, s);
      rethrow;
    }

    ref.invalidateSelf();
  }
}
