import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'polypharmacy_repo.g.dart';

@riverpod
PolypharmacyRepo polypharmacyRepo(PolypharmacyRepoRef ref) {
  return PolypharmacyRepo(
    PolypharmacyApi(
      dio: Dio(),
    ),
  );
}

class PolypharmacyRepo {
  late final PolypharmacyApi _polypharmacyApi;

  PolypharmacyRepo(PolypharmacyApi polypharmacyApi) {
    _polypharmacyApi = polypharmacyApi;
  }

  Future<String> fetchSecureData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final authToken = await user!.getIdToken();

    try {
      final result = await _polypharmacyApi.getSecureData("Bearer ${authToken!}");
      print(result);
      return result;
    } on DioException catch (dioError) {
      rethrow;
    }
  }
}

@RestApi(baseUrl: "https://polypharmacyappbackend.azurewebsites.net")
abstract class PolypharmacyApi {
  factory PolypharmacyApi({required Dio dio}) => _PolypharmacyApi(dio);

  @GET("/secure-data")
  Future<String> getSecureData(@Header('auth-header') String token);
}
