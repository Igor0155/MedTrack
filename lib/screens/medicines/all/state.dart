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

  // Future<OutputChangeTokenCustomerDto> selectNewClientAndChangeToken(InputChangeToken input) async {
  //   isLoading = true;
  //   notifyListeners();

  //   final response = await client.put('/api/v1/auth/${input.targetType}/${input.cuid}/change-token');
  //   if (response.isSuccess) {
  //     var result = OutputChangeTokenCustomerDto.fromJson(response.data);
  //     await clientSharedPreferences.clean('token');
  //     await clientSharedPreferences.set("token", result.newToken);
  //     isLoading = false;
  //     notifyListeners();
  //     return result;
  //   } else {
  //     if (response.statusCode != 500) {
  //       // Mandar o usuário para o login
  //       isLoading = false;
  //       notifyListeners();
  //       await logout();
  //       throw GEDocsException('return-login');
  //     } else {
  //       isLoading = false;
  //       notifyListeners();
  //       throw GEDocsException(response.data['message']);
  //     }
  //   }
  // }
}
