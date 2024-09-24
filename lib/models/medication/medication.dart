import 'package:freezed_annotation/freezed_annotation.dart';

import '../pill_schedule/pill_schedule.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

@freezed
class Medication with _$Medication {
  const factory Medication({
    required String name,
    required String dosage,
    required int pillId,
    required List<PillSchedule> schedules,
  }) = _Medication;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
}
