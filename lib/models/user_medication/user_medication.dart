import 'package:freezed_annotation/freezed_annotation.dart';

import '../pill_schedule/pill_schedule.dart';

part 'user_medication.freezed.dart';
part 'user_medication.g.dart';

@freezed
class Medication with _$Medication {
  const factory Medication({
    required String name,
    required String dosage,
    required List<PillSchedule> schedules,
    required int pillId,
  }) = _UserMedication;

  factory Medication.fromJson(Map<String, dynamic> json) => _$MedicationFromJson(json);
}
