import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polypharmacy/models/pill_consumption/pill_consumption.dart';
import 'package:polypharmacy/models/pill_schedule/pill_schedule.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/http_responses/success.dart';

part 'polypharmacy_repo.g.dart';

@riverpod
Future<PolypharmacyRepo> polypharmacyRepo(PolypharmacyRepoRef ref) async {
  User? user = FirebaseAuth.instance.currentUser;
  final authToken = await user!.getIdToken();

  final dio = Dio();
  dio.options.headers = {'auth-header': "Bearer ${authToken!}"};
  return PolypharmacyRepo(
    PolypharmacyApi(dio: dio),
  );
}

class PolypharmacyRepo {
  late final PolypharmacyApi _polypharmacyApi;

  PolypharmacyRepo(PolypharmacyApi polypharmacyApi) {
    _polypharmacyApi = polypharmacyApi;
  }

  Future<Success> deletePill(int pillId) async {
    await Future.delayed(const Duration(seconds: 1));
    return Success();
  }

  Future<List<PillSchedule>> getPillSchedules() async {
    // try {
    //   final result = await _polypharmacyApi.getPillSchedules(1000);
    //   print(result);
    //   return result;
    // } on DioException catch (dioError) {
    //   print(dioError.toString());
    //   rethrow;
    // } catch(ex){
    //   print(ex.toString());
    //   rethrow;
    // }
    await Future.delayed(const Duration(seconds: 2));
    return [
      PillSchedule(
        name: 'Aspirin',
        dosage: '100mg',
        pillId: 1,
        quantity: 1,
        time: DateTime(1970, 1, 1, 7, 0),
        userId: 101,
        id: 1,
      ),
      PillSchedule(
        name: 'Aspirin',
        dosage: '100mg',
        pillId: 1,
        quantity: 2,
        time: DateTime(1970, 1, 1, 12, 0),
        userId: 101,
        id: 1,
      ),
      PillSchedule(
        name: 'Aspirin',
        dosage: '100mg',
        pillId: 1,
        quantity: 3,
        time: DateTime(1970, 1, 1, 20, 0),
        userId: 101,
        id: 1,
      ),
      PillSchedule(
        name: 'Ibuprofen',
        dosage: '200mg',
        pillId: 2,
        quantity: 2,
        time: DateTime(1970, 1, 1, 12, 0),
        userId: 102,
        id: 2,
      ),
      PillSchedule(
        name: 'Paracetamol',
        dosage: '500mg',
        pillId: 3,
        quantity: 3,
        time: DateTime(1970, 1, 1, 7, 0),
        userId: 103,
        id: 3,
      ),
      PillSchedule(
        name: 'Paracetamol',
        dosage: '500mg',
        pillId: 3,
        quantity: 3,
        time: DateTime(1970, 1, 1, 20, 0),
        userId: 103,
        id: 3,
      ),
      PillSchedule(
        name: 'Prozac',
        dosage: '25mg',
        pillId: 4,
        quantity: 2,
        time: DateTime(1970, 1, 1, 20, 0),
        userId: 105,
        id: 5,
      ),
      PillSchedule(
        name: 'Amoxicillin',
        dosage: '250mg',
        pillId: 5,
        quantity: 1,
        time: DateTime(1970, 1, 1, 7, 0),
        userId: 105,
        id: 5,
      ),
      PillSchedule(
        name: 'Amoxicillin',
        dosage: '250mg',
        pillId: 5,
        quantity: 1,
        time: DateTime(1970, 1, 1, 12, 0),
        userId: 105,
        id: 5,
      ),
      PillSchedule(
        name: 'Amoxicillin',
        dosage: '250mg',
        pillId: 5,
        quantity: 2,
        time: DateTime(1970, 1, 1, 20, 0),
        userId: 105,
        id: 5,
      ),
    ];
  }

  Future<Success> postPillSchedule(PillSchedule pillSchedule) async {
    await Future.delayed(const Duration(seconds: 1));
    return Success();
  }

  Future<Success> putPillSchedule(int pillScheduleId) async {
    await Future.delayed(const Duration(seconds: 1));
    return Success();
  }

  Future<Success> deletePillSchedule(int pillScheduleId) async {
    await Future.delayed(const Duration(seconds: 1));
    return Success();
  }

  Future<List<PillConsumption>> getPillConsumptions() async {
    // final result = await _polypharmacyApi.getPillConsumptions();
    await Future.delayed(const Duration(seconds: 2));
    final today7AM = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      7, // 7:00 AM
      0, // Minutes
      0, // Seconds
    );

    final today12PM = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      12, // 12:00 AM
      0, // Minutes
      0, // Seconds
    );

    final pill1 = PillConsumption(
      pillId: 1,
      quantity: 1,
      time: today7AM,
      id: 1,
    );

    final pill2 = PillConsumption(
      pillId: 2,
      quantity: 2,
      time: today12PM,
      id: 2,
    );

    final pill3 = PillConsumption(
      pillId: 3,
      quantity: 1,
      time: today7AM,
      id: 3,
    );

    return [pill1, pill2, pill3];
  }

  Future<PillConsumption> postPillConsumption(
      PillConsumption pillConsumption) async {
    await Future.delayed(const Duration(seconds: 1));
    // final result = await _polypharmacyApi.postPillConsumption(pillConsumption);
    return PillConsumption(
        pillId: pillConsumption.pillId,
        quantity: pillConsumption.hashCode,
        time: pillConsumption.time,
        id: 4);
  }

  Future<Success> deletePillConsumption(int pillConsumptionId) async {
    await Future.delayed(const Duration(seconds: 1));
    // final result = await _polypharmacyApi.deletePillConsumption(pillConsumptionId);
    return Success();
  }
}

@RestApi(baseUrl: "https://polypharmacyappbackend.azurewebsites.net")
abstract class PolypharmacyApi {
  factory PolypharmacyApi({required Dio dio}) => _PolypharmacyApi(dio);

  @DELETE("/pill/{pill_id}")
  Future<void> deletePill(
    @Path('pill_id') int pillId,
  );

  @GET("/pill_schedule")
  Future<List<PillSchedule>> getPillSchedules(@Query('limit') int limit);

  @GET("/pill_schedule")
  Future<List<PillSchedule>> postPillSchedule();

  @PUT("/pill_schedule/{pill_schedule_id}")
  Future<void> putPillSchedule(
    @Path('pill_schedule_id') int pillScheduleId,
  );

  @DELETE("/pill_schedule/{pill_schedule_id}")
  Future<void> deletePillSchedule(
    @Path('pill_schedule_id') int pillScheduleId,
  );

  @GET("/pill_consumption")
  Future<List<PillConsumption>> getPillConsumptions();

  @GET("/pill_consumption")
  Future<List<PillConsumption>> postPillConsumption(
    @Body() PillConsumption pillConsumption,
  );

  @DELETE("/pill_consumption/{pill_consumption_id}")
  Future<PillConsumption> deletePillConsumption(
    @Path('pill_consumption_id') int pillConsumptionId,
  );
}
