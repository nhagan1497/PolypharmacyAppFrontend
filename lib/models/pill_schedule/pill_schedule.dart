import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'pill_schedule.freezed.dart';
part 'pill_schedule.g.dart';

@freezed
class PillSchedule with _$PillSchedule {
  const factory PillSchedule({
    required String name,
    required String dosage,
    required int? pillId,
    required int quantity,
    @JsonKey(fromJson: _fromJson, toJson: _toJson)
    required TimeOfDay time,
    required int? userId,
    required int? id,
  }) = _PillSchedule;

  factory PillSchedule.fromJson(Map<String, dynamic> json) =>
      _$PillScheduleFromJson(json);
}

TimeOfDay _fromJson(String dateTime) {
  final date = DateTime.parse(dateTime);
  return TimeOfDay(hour: date.hour, minute: date.minute);
}

String _toJson(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return dateTime.toUtc().toIso8601String();
}
