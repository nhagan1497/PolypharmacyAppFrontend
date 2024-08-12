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
    try {
      final result = await _polypharmacyApi.getPillSchedules(1000);
      print(result);
      return result;
    } on DioException catch (dioError) {
      print(dioError.toString());
      rethrow;
    } catch(ex){
      print(ex.toString());
      rethrow;
    }
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
