import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/pill/pill.dart';
import '../../repos/polypharmacy_repo.dart';

part 'pill_identification_state.g.dart';

@riverpod
class PillIdentificationState extends _$PillIdentificationState {
  @override
  Future<Pill> build(File imageFile) async {
    final polypharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    return await polypharmacyRepo.postPillIdentification(image: imageFile);
  }
}
