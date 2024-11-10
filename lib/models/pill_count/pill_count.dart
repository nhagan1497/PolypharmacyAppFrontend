import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_count.freezed.dart';
part 'pill_count.g.dart';

@freezed
class PillCount with _$PillCount {
  const factory PillCount({
    @JsonKey(name: 'remaining_pill_count') required int remainingPillCount,
  }) = _PillCount;

  factory PillCount.fromJson(Map<String, dynamic> json) =>
      _$PillCountFromJson(json);
}
