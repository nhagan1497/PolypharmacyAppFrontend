import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/pill/pill.dart';
import '../../repos/polypharmacy_repo.dart';

part 'pill_identification_state.g.dart';

@riverpod
class PillIdentificationState extends _$PillIdentificationState {
  @override
  Future<Pill> build(MultipartFile imageMultipartFile) async {
    final polypharmacyRepo = ref.watch(polypharmacyRepoProvider).value!;
    return await polypharmacyRepo.postPillIdentification(imageMultipartFile);
  }
}