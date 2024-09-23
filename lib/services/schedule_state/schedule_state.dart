import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:polypharmacy/services/medication_state/medication_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../models/pill_schedule/pill_schedule.dart';
import '../../repos/polypharmacy_repo.dart';
import '../../utilities/time_helpers.dart';

part 'schedule_state.g.dart';
part 'schedule_state.freezed.dart';

@freezed
class ScheduleStateData with _$ScheduleStateData {
  const factory ScheduleStateData({
    @Default(IList<PillSchedule>.empty()) IList<PillSchedule> originalSchedules,
    @Default(IList<PillSchedule>.empty()) IList<PillSchedule> schedules,
    @Default(false) bool successfullyUpdatedSchedules,
  }) = _ScheduleStateData;
}

@Riverpod(keepAlive: true)
class ScheduleState extends _$ScheduleState {
  @override
  Future<ScheduleStateData> build() async {
    final medicationState = ref.watch(medicationStateProvider).valueOrNull;
    final selectedMedication = medicationState?.selectedMedication;
    final originalSchedules = selectedMedication?.schedules ?? [];
    return ScheduleStateData(
        originalSchedules: originalSchedules.lock,
        schedules: originalSchedules.lock);
  }

  Future<void> sendScheduleRequests() async {
    state = const AsyncLoading();
    final currentState = state.value!;
    final addedSchedules =
      currentState.originalSchedules.isEmpty
        ? currentState.schedules.toList()
        : currentState.schedules
            .where((schedule) => !currentState.originalSchedules
                .any((original) => original.id == schedule.id))
            .toList();

    final List<PillSchedule> updatedSchedules = [];
    for (var originalSchedule in currentState.originalSchedules) {
      final schedule = currentState.schedules
          .firstWhereOrNull((schedule) => schedule.id == originalSchedule.id);
      if (schedule != null &&
          (originalSchedule.quantity != schedule.quantity ||
              originalSchedule.time != schedule.time)) {
        {
          updatedSchedules.add(schedule);
        }
      }
    }

    final deletedSchedules = currentState.originalSchedules
        .where((original) =>
            !currentState.schedules.any((schedule) => schedule.id == original.id))
        .toList();

    final futures = <Future>[];
    if (addedSchedules.isNotEmpty) {
      futures.add(sendPillScheduleCreateRequests(addedSchedules));
    }
    if (updatedSchedules.isNotEmpty) {
      futures.add(sendPillScheduleUpdateRequests(updatedSchedules));
    }
    if (deletedSchedules.isNotEmpty) {
      futures.add(sendPillScheduleDeleteRequests(deletedSchedules));
    }

    await Future.wait(futures);

    state = AsyncData(currentState.copyWith(
       successfullyUpdatedSchedules: true));
  }

  Future<void> sendPillScheduleCreateRequests(List<PillSchedule> schedulesToCreate) async {
    final polypharmacyRepo = await ref.read(polypharmacyRepoProvider.future);
    final json = schedulesToCreate.first.toJson();

    final futures = schedulesToCreate.map((schedule) {
      return polypharmacyRepo.postPillSchedule("application/json", pillSchedule: schedule);
    }).toList();

    await Future.wait(futures);
  }


  Future<void> sendPillScheduleUpdateRequests(List<PillSchedule> schedulesToUpdate) async {
    final polypharmacyRepo = await ref.read(polypharmacyRepoProvider.future);

    final futures = schedulesToUpdate.map((schedule) {
      return polypharmacyRepo.putPillSchedule(pillScheduleId: schedule.id, pillSchedule: schedule);
    }).toList();

    await Future.wait(futures);
  }

  Future<void> sendPillScheduleDeleteRequests(List<PillSchedule> schedulesToDelete) async {
    final polypharmacyRepo = await ref.read(polypharmacyRepoProvider.future);

    final futures = schedulesToDelete.map((schedule) {
      return polypharmacyRepo.deletePillSchedule(pillScheduleId: schedule.id);
    }).toList();

    await Future.wait(futures);
  }



  void addSchedule(String quantity, TimeOfDay time) {
    final currentState = state.value!;
    final schedule = _createPillSchedule(quantity, time);
    state = AsyncData(currentState.copyWith(schedules: currentState.schedules.add(schedule)));
  }

  void updateSchedule(int index, String quantity, TimeOfDay time) {
    final currentState = state.value!;

    final schedule = _createPillSchedule(quantity, time);
    state = AsyncData(currentState.copyWith(
        schedules: currentState.schedules.removeAt(index).add(schedule)));
  }

  void addScheduleToDelete(PillSchedule schedule) {
    final currentState = state.value!;

    state = AsyncData(currentState.copyWith(schedules: currentState.schedules.remove(schedule)));
  }

  PillSchedule _createPillSchedule(String quantity, TimeOfDay time) {
    final medicationState = ref.read(medicationStateProvider).value!;
    return PillSchedule(
        pillId: medicationState.selectedMedication?.pillId ?? 0,
        quantity: int.parse(quantity),
        time: time,
        id: 0);
  }
}
