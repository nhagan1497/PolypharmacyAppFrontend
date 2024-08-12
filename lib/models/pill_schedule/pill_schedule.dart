import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'pill_schedule.freezed.dart';
part 'pill_schedule.g.dart';

@freezed
class PillSchedule with _$PillSchedule {
  const factory PillSchedule({
    required int? pillId,
    required int? quantity,
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required DateTime time,
    required int? userId,
    required int? id,
  }) = _PillSchedule;

  factory PillSchedule.fromJson(Map<String, dynamic> json) => _$PillScheduleFromJson(json);
}

DateTime _fromJson(String date) => DateFormat("HH:mm:ss.SSS").parse(date);
String _toJson(DateTime date) => DateFormat("HH:mm:ss.SSS").format(date);
