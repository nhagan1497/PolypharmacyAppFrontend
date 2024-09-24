import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polypharmacy/models/pill_consumption/pill_consumption.dart';
import 'package:polypharmacy/models/pill_schedule/pill_schedule.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/pill/pill.dart';
import '../utilities/dio_interceptor.dart';
import 'package:http_parser/http_parser.dart';

part 'polypharmacy_repo.g.dart';

@riverpod
Future<PolypharmacyRepo> polypharmacyRepo(PolypharmacyRepoRef ref) async {
  User? user = FirebaseAuth.instance.currentUser;
  final authToken = await user!.getIdToken();

  final dio = Dio();
  dio.options.headers = {'auth-header': "Bearer ${authToken!}"};
  dio.interceptors.add(DioInterceptor());
  return PolypharmacyRepo(dio: dio);
}

@RestApi(baseUrl: "https://polypharmacyappbackend.azurewebsites.net")
abstract class PolypharmacyRepo {
  factory PolypharmacyRepo({required Dio dio}) => _PolypharmacyRepo(dio);

  // **************************************************************************
  // * Pill Endpoints                                                         *
  // **************************************************************************
  @GET("/pills/")
  Future<List<Pill>> getPills();

  @POST("/pills/identify/")
  @MultiPart()
  Future<Pill> postPillIdentification({
    @Part(name: "image", contentType: "image/png") required File image,
  });

  @POST("/pills/")
  @MultiPart()
  Future<Pill> postPill({
    @Part(name: "image", contentType: "image/png") required File image,
    @Query('name') required String name,
    @Query('dosage') required String dosage,
    @Query('manufacturer') required String manufacturer,
  });

  @DELETE("/pill/{pill_id}/")
  Future<void> deletePill(
    @Path('pill_id') int pillId,
  );

  // **************************************************************************
  // * Pill Consumption Endpoints                                             *
  // **************************************************************************
  @GET("/pill_consumption/")
  Future<List<PillConsumption>> getPillConsumptions(
      @Query('skip') int? skip, // default - 0
      @Query('limit') int? limit // default - 10
      );

  @POST("/pill_consumption/")
  Future<PillConsumption> postPillConsumption({
    @Header('content-type') required String contentType,
    @Body() required PillConsumption pillConsumption,
  });

  @DELETE("/pill_consumption/{pill_consumption_id}")
  Future<PillConsumption> deletePillConsumption({
    @Path('pill_consumption_id') required int pillConsumptionId,
  });

  // **************************************************************************
  // * Pill Schedule Endpoints                                                *
  // **************************************************************************
  @GET("/pill_schedule/")
  Future<List<PillSchedule>> getPillSchedules(
      @Query('skip') int? skip, // default - 0
      @Query('limit') int? limit // default - 10
      );

  @POST("/pill_schedule/")
  Future<PillSchedule> postPillSchedule(
      {@Header('content-type') required String contentType,
      @Body() required PillSchedule pillSchedule});

  @PUT("/pill_schedule/{pill_schedule_id}/")
  Future<PillSchedule> putPillSchedule(
      {@Path('pill_schedule_id') required int pillScheduleId,
      @Body() required PillSchedule pillSchedule});

  @DELETE("/pill_schedule/{pill_schedule_id}/")
  Future<PillSchedule> deletePillSchedule({
    @Path('pill_schedule_id') required int pillScheduleId,
  });
}
