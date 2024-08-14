import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polypharmacy/models/pill_schedule/pill_schedule.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'polypharmacy_repo.g.dart';

@riverpod
Future<PolypharmacyRepo> polypharmacyRepo(PolypharmacyRepoRef ref) async {
  User? user = FirebaseAuth.instance.currentUser;
  final authToken = await user!.getIdToken();

  final dio = Dio();
  dio.options.headers = {
    'auth-header' : "Bearer ${authToken!}"
  };
  return PolypharmacyRepo(
    PolypharmacyApi(dio: dio),
  );
}

class PolypharmacyRepo {
  late final PolypharmacyApi _polypharmacyApi;

  PolypharmacyRepo(PolypharmacyApi polypharmacyApi) {
    _polypharmacyApi = polypharmacyApi;
  }

  Future<String> fetchSecureData() async {
    try {
      final result = await _polypharmacyApi.getSecureData();
      print(result);
      return result;
    } on DioException catch (dioError) {
      rethrow;
    }
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
        quantity: 2,
        time: DateTime(2024, 8, 14, 7, 0),
        userId: 101,
        id: 1,
      ),
      PillSchedule(
        name: 'Aspirin',
        dosage: '100mg',
        pillId: 1,
        quantity: 2,
        time: DateTime(2024, 8, 14, 12, 0),
        userId: 101,
        id: 1,
      ),
      PillSchedule(
        name: 'Aspirin',
        dosage: '100mg',
        pillId: 1,
        quantity: 2,
        time: DateTime(2024, 8, 14, 20, 0),
        userId: 101,
        id: 1,
      ),
      PillSchedule(
        name: 'Ibuprofen',
        dosage: '200mg',
        pillId: 2,
        quantity: 2,
        time: DateTime(2024, 8, 14, 12, 0),
        userId: 102,
        id: 2,
      ),
      PillSchedule(
        name: 'Paracetamol',
        dosage: '500mg',
        pillId: 3,
        quantity: 3,
        time: DateTime(2024, 8, 14, 7, 0),
        userId: 103,
        id: 3,
      ),
      PillSchedule(
        name: 'Paracetamol',
        dosage: '500mg',
        pillId: 3,
        quantity: 3,
        time: DateTime(2024, 8, 14, 20, 0),
        userId: 103,
        id: 3,
      ),
      PillSchedule(
        name: 'Amoxicillin',
        dosage: '250mg',
        pillId: 5,
        quantity: 1,
        time: DateTime(2024, 8, 14, 7, 0),
        userId: 105,
        id: 5,
      ),
      PillSchedule(
        name: 'Amoxicillin',
        dosage: '250mg',
        pillId: 5,
        quantity: 1,
        time: DateTime(2024, 8, 14, 12, 0),
        userId: 105,
        id: 5,
      ),
      PillSchedule(
        name: 'Amoxicillin',
        dosage: '250mg',
        pillId: 5,
        quantity: 1,
        time: DateTime(2024, 8, 14, 20, 0),
        userId: 105,
        id: 5,
      ),
    ];
  }

}

@RestApi(baseUrl: "https://polypharmacyappbackend.azurewebsites.net")
abstract class PolypharmacyApi {
  factory PolypharmacyApi({required Dio dio}) => _PolypharmacyApi(dio);

  @GET("/secure-data")
  Future<String> getSecureData();
  
  @GET("/pill_schedule/")
  Future<List<PillSchedule>> getPillSchedules(
    @Query('limit') int limit
  );
}
