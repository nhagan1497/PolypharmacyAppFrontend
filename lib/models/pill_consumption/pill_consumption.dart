import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_consumption.freezed.dart';
part 'pill_consumption.g.dart';

@freezed
class PillConsumption with _$PillConsumption {
  const factory PillConsumption({
    @JsonKey(name: 'pill_id') required int pillId,
    required int quantity,
    @JsonKey(fromJson: _fromJson, toJson: _toJson)
    required TimeOfDay time,
    @Default(null) int? id,
  }) = _PillConsumption;

  factory PillConsumption.fromJson(Map<String, dynamic> json) =>
      _$PillConsumptionFromJson(json);
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