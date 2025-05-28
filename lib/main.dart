import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:meditrack/app/initialization_widget.dart';
import 'package:meditrack/shared/helpers/create_dio_instance.dart';
import 'package:meditrack/shared/helpers/create_dio_medicine_instance.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';
import 'package:meditrack/shared/services/dio_client_http.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingletonAsync<IClientSharedPreferences>(() => ClientSharedPreferences.init());

  getIt.registerSingleton<Dio>(createDioInstance("http://10.0.2.2:8080"));

  // Novo Dio com baseURL específica para medicamentos
  getIt.registerSingleton<Dio>(
    createDioMedicineInstance("https://api.interage.intmed.com.br/"),
    instanceName: 'dio_medicine',
  );

  getIt.registerSingletonAsync<IClientHttp>(() async {
    final dio = getIt.get<Dio>();
    return DioClientHttp(dio);
  });

  // Registrar DioClientMedicine com o novo Dio
  getIt.registerSingleton<DioClientMedicine>(
    DioClientMedicine(getIt<Dio>(instanceName: 'dio_medicine')),
  );

  runApp(ProviderScope(child: InitializationWidget(getIt: getIt)));
}
