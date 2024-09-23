import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:polypharmacy/services/medication_state/medication_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../models/pill_schedule/pill_schedule.dart';

part 'schedule_state.g.dart';
part 'schedule_state.freezed.dart';

@freezed
class ScheduleStateData with _$ScheduleStateData {
  const factory ScheduleStateData({
    @Default(IList<PillSchedule>.empty()) IList<PillSchedule> originalSchedules,
    @Default(IList<PillSchedule>.empty()) IList<PillSchedule> schedules,
  }) = _ScheduleStateData;
}

@Riverpod(keepAlive: true)
class ScheduleState extends _$ScheduleState {
  @override
  ScheduleStateData build() {
    final medicationState = ref.watch(medicationStateProvider).valueOrNull;
    final selectedMedication = medicationState?.selectedMedication;
    final originalSchedules = selectedMedication?.schedules ?? [];
    return ScheduleStateData(
        originalSchedules: originalSchedules.lock,
        schedules: originalSchedules.lock);
  }

  void addSchedule(String quantity, TimeOfDay time) {
    final schedule = _createPillSchedule(quantity, time);
    state = state.copyWith(schedules: state.schedules.add(schedule));
  }

  void updateSchedule(String quantity, TimeOfDay time) {
    final schedule = _createPillSchedule(quantity, time);
    state = state.copyWith(
        schedules: state.schedules
            .removeWhere((sch) =>
                sch.quantity == schedule.quantity && sch.time == schedule.time)
            .add(schedule));
  }

  void addScheduleToDelete(PillSchedule schedule) {
    state = state.copyWith(schedules: state.schedules.remove(schedule));
  }

  PillSchedule _createPillSchedule(String quantity, TimeOfDay time) {
    final medicationState = ref.read(medicationStateProvider).value!;
    return PillSchedule(
        name: "",
        dosage: "",
        pillId: medicationState.selectedMedication?.pillId ?? 0,
        quantity: int.parse(quantity),
        time: time,
        userId: 0,
        id: 0);
  }
}
