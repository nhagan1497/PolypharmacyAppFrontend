import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'pill_schedule.freezed.dart';
part 'pill_schedule.g.dart';

@freezed
class PillSchedule with _$PillSchedule {
  const factory PillSchedule({
    required int id,
    @JsonKey(name: 'pill_id') required int pillId,
    required int quantity,
    @JsonKey(fromJson: _fromJson, toJson: _toJson)
    required TimeOfDay time,
  }) = _PillSchedule;

  factory PillSchedule.fromJson(Map<String, dynamic> json) =>
      _$PillScheduleFromJson(json);
}

TimeOfDay _fromJson(String timeString) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}


String _toJson(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return dateTime.toUtc().toIso8601String().split("T")[1];
}
