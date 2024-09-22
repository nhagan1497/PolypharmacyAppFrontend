import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill.freezed.dart';
part 'pill.g.dart';

@freezed
class Pill with _$Pill {
  const factory Pill({
    required int id,
    required String name,
    required String dosage,
    required String manufacturer,
  }) = _Pill;

  factory Pill.fromJson(Map<String, dynamic> json) => _$PillFromJson(json);
}
