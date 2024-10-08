import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_consumption.freezed.dart';
part 'pill_consumption.g.dart';

@freezed
class PillConsumption with _$PillConsumption {
  const factory PillConsumption({
    @JsonKey(name: 'pill_id') required int pillId,
    required int quantity,
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required DateTime time,
    @Default(null) int? id,
  }) = _PillConsumption;

  factory PillConsumption.fromJson(Map<String, dynamic> json) =>
      _$PillConsumptionFromJson(json);
}

DateTime _fromJson(String dateTime) {
  return DateTime.parse(dateTime);
}

String _toJson(DateTime time) {
  return time.toIso8601String();
}
