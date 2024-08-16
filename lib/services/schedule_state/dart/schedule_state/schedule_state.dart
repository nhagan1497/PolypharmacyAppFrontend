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
    @Default([]) List<PillSchedule> schedules,
    @Default({}) Set<PillSchedule> schedulesToCreate,
    @Default({}) Set<PillSchedule> schedulesToUpdate,
    @Default({}) Set<PillSchedule> schedulesToDelete,
  }) = _ScheduleStateData;
}

@riverpod
class ScheduleState extends _$ScheduleState {
  @override
  ScheduleStateData build(){
    final medicationState = ref.watch(medicationStateProvider).valueOrNull;
    final selectedMedication = medicationState?.selectedMedication;
    return ScheduleStateData(schedules: selectedMedication?.schedules ?? []);
  }

  void addScheduleToCreate(String quantity, TimeOfDay time) {
    final schedule = _createPillSchedule(quantity, time);
    state = state.copyWith(
        schedulesToCreate: {...state.schedulesToCreate, schedule}
    );
    _addToSchedules(schedule);
  }

  void addScheduleToUpdate(int index, String quantity, TimeOfDay time) {
    final medicationState = ref.read(medicationStateProvider).value!;
    final selectedMedication = medicationState.selectedMedication;
    final schedule = _createPillSchedule(quantity, time);
    if (selectedMedication == null){
      state = state.copyWith(
          schedulesToCreate: {...state.schedulesToCreate, schedule}
      );
    }
    else {
      state = state.copyWith(
          schedulesToUpdate: {...state.schedulesToUpdate, schedule}
      );
    }
    deleteSchedule(index);
    _addToSchedules(schedule);
  }

  void addScheduleToDelete(int index) {
    final scheduleToDelete = state.schedules[index];
    final medicationState = ref.read(medicationStateProvider).value!;
    final selectedMedication = medicationState.selectedMedication;
    if (selectedMedication != null){
      state = state.copyWith(
          schedulesToDelete: {...state.schedulesToDelete, scheduleToDelete}
      );
    }
    deleteSchedule(index);
  }

  void deleteSchedule(int index){
    final schedule = state.schedules[index];
    state = state.copyWith(
        schedules: state.schedules.where((element) => element != schedule).toList()
    );
  }

  void _addToSchedules(PillSchedule schedule) {
    if (!state.schedules.contains(schedule))
    {
      state = state.copyWith(schedules: [...state.schedules, schedule]);
    }
  }

  PillSchedule _createPillSchedule(String quantity, TimeOfDay time){
    final medicationState = ref.read(medicationStateProvider).value!;
    return PillSchedule(
        name: "",
        dosage: "",
        pillId: medicationState.selectedMedication?.pillId ?? 0,
        quantity: int.parse(quantity),
        time: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          time.hour,
          time.minute,
        ),
        userId: 0,
        id: 0
    );
  }
}
