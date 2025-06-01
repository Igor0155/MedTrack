import 'package:flutter/material.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/api_medicine_response.dart';
import 'package:meditrack/shared/types/medicine_presentation.dart';

class StateSelectMedicine with ChangeNotifier {
  final DioClientMedicine clientMedicine;
  bool isLoading = true;
  late bool medException;
  late String medExceptionMessage;

  ApiMedicineResponse<MedicinePresentation>? _medicines;
  ApiMedicineResponse<MedicinePresentation>? get medicines => _medicines;

  StateSelectMedicine({required this.clientMedicine});

  Future<void> searchMedicine() async {
    try {
      medExceptionMessage = '';
      isLoading = true;
      medException = false;
      notifyListeners();
      var response = await clientMedicine.get('/v1/apresentacao-medicamentos/?page_size=200');

      _medicines = ApiMedicineResponse<MedicinePresentation>.fromJson(
        response.data,
        (json) => MedicinePresentation.fromJson(json),
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      medExceptionMessage = e.toString();
      isLoading = false;
      medException = true;
      notifyListeners();
    }
  }
}
