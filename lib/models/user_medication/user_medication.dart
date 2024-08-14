import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_medication.freezed.dart';
part 'user_medication.g.dart';

@freezed
class UserMedication with _$UserMedication {
  const factory UserMedication({
    required String name,
    required String dosage,
    required int quantity,
    required List<String> timesOfDay,
  }) = _UserMedication;

  factory UserMedication.fromJson(Map<String, dynamic> json) => _$UserMedicationFromJson(json);
}
