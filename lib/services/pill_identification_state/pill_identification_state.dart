import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/pill/pill.dart';
import '../../repos/polypharmacy_repo.dart';
import '../../utilities/time_helpers.dart';
import '../medication_state/medication_state.dart';

part 'pill_identification_state.g.dart';
part 'pill_identification_state.freezed.dart';

@riverpod
class PillIdentificationState extends _$PillIdentificationState {
  @override
  Future<Pill> build(File imageFile) async {
    final polypharmacyRepo = await ref.read(polypharmacyRepoProvider.future);
    return await polypharmacyRepo.postPillIdentification(image: imageFile);
  }
}

@freezed
class MultiPillIdentificationResult with _$MultiPillIdentificationResult {
  const factory MultiPillIdentificationResult({
    required IMap<Pill, int> correctPills,
    required IMap<Pill, int> missingPills,
    required IMap<Pill, int> unexpectedPills,
  }) = _MultiPillIdentificationResult;
}

@riverpod
class MultiPillIdentificationState extends _$MultiPillIdentificationState {
  @override
  Future<MultiPillIdentificationResult> build(
      File imageFile, TimeOfDay time) async {
    final medicationState = ref.watch(medicationStateProvider).value!;
    final medicationsInRound = medicationState.medicationRounds[time];

    // Create the expected pills list
    final expectedPills = medicationsInRound!
        .map((medication) {
      final quantity = medication.schedules
          .firstWhere((schedule) => isSameTime(schedule.time, time))
          .quantity;
      final pill = medicationState.pills
          .firstWhere((p) => p.id == medication.pillId);
      return MapEntry(pill, quantity);
    })
        .expand((entry) => List.generate(entry.value, (_) => entry.key))
        .toList();

    final polypharmacyRepo = await ref.read(polypharmacyRepoProvider.future);
    final identifiedPills =
    await polypharmacyRepo.postPillScheduleIdentification(image: imageFile);

    // Count the identified pills
    final identifiedPillCounts = <Pill, int>{};
    for (var pill in identifiedPills) {
      identifiedPillCounts[pill] = (identifiedPillCounts[pill] ?? 0) + 1;
    }

    // Prepare the result maps
    IMap<Pill, int> correctPills = IMap<Pill, int>();
    IMap<Pill, int> missingPills = IMap<Pill, int>();
    IMap<Pill, int> unexpectedPills = IMap<Pill, int>();

    // Identify expected pills counts
    final expectedPillCounts = <Pill, int>{};
    for (var pill in expectedPills) {
      expectedPillCounts[pill] = (expectedPillCounts[pill] ?? 0) + 1;
    }

    // Check for correct and missing pills
    for (var entry in expectedPillCounts.entries) {
      final pill = entry.key;
      final expectedQuantity = entry.value;
      final identifiedQuantity = identifiedPillCounts[pill] ?? 0;

      if (identifiedQuantity == expectedQuantity) {
        correctPills = correctPills.add(pill, expectedQuantity);
      } else if (identifiedQuantity < expectedQuantity) {
        missingPills = missingPills.add(pill, expectedQuantity - identifiedQuantity);
        if (identifiedQuantity > 0) {
          correctPills = correctPills.add(pill, identifiedQuantity);
        }
      }
      else{
        correctPills = correctPills.add(pill, expectedQuantity);
        unexpectedPills = unexpectedPills.add(pill, identifiedQuantity - expectedQuantity);
      }
    }

    // Check for unexpected pills
    for (var entry in identifiedPillCounts.entries) {
      final pill = entry.key;
      final identifiedQuantity = entry.value;

      if (!expectedPillCounts.containsKey(pill)) {
        // Add to unexpected pills
        unexpectedPills = unexpectedPills.add(pill, identifiedQuantity);
      }
    }

    return MultiPillIdentificationResult(
      correctPills: correctPills,
      missingPills: missingPills,
      unexpectedPills: unexpectedPills,
    );
  }
}
