import 'package:flutter/material.dart';
import 'package:meditrack/screens/medicines/components/item_list.dart';
import 'package:meditrack/shared/custom_clipper/bottom_clipper.dart';
import 'package:meditrack/shared/custom_clipper/custom_clipper.dart';
import 'package:meditrack/shared/types/medicine_presentation.dart';
import 'package:meditrack/shared/types/medicines.dart';

class Search extends SearchDelegate {
  final List<MedicinePresentation> searchExemple;
  final bool isTablet;
  Search({required this.searchExemple, required this.isTablet});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(inputDecorationTheme: const InputDecorationTheme(focusedBorder: null));
  }

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 20);

  @override
  String get searchFieldLabel => 'Nome, concentração, forma farm, detentor';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> search = searchExemple.map<Map<String, dynamic>>((value) {
      return {
        'id': value.id,
        'nome': value.name,
        'concentracao': value.concentration,
        'forma_farmaceutica': value.pharmaceuticalForm,
        'detentor': value.detentor,
        'principio_ativo': value.medicine.principlesActives,
      };
    }).toList();

    List<Map<String, dynamic>> resultSearch = search.where((item) {
      bool isExistsName = item['nome'].toLowerCase().contains(query.toLowerCase());
      bool isExistsConcentration = item['concentracao'].toLowerCase().contains(query.toLowerCase());
      bool isExistsPharmaceuticalForm = item['forma_farmaceutica'].toLowerCase().contains(query.toLowerCase());
      bool isExistsDetentor = item['detentor'].toLowerCase().contains(query.toLowerCase());
      bool isExistsPrincipleActive = (item['principio_ativo'] as List<PrinciplesActivesDto>)
          .any((active) => active.name.toLowerCase().contains(query.toLowerCase()));

      return isExistsName ||
          isExistsConcentration ||
          isExistsPharmaceuticalForm ||
          isExistsDetentor ||
          isExistsPrincipleActive;
    }).toList();

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          if (!isKeyboardOpen) bottomClipper(),
          ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: resultSearch.length,
              itemBuilder: (BuildContext context, index) {
                var medicine = searchExemple.firstWhere((item) => item.id == resultSearch[index]['id'],
                    orElse: () => MedicinePresentation(
                          concentration: '',
                          detentor: '',
                          pharmaceuticalForm: '',
                          id: 0,
                          name: '',
                          url: '',
                          medicine:
                              MedicineDto(principlesActives: [], id: 0, url: '', name: '', ingredientsActiveAnvisa: []),
                        ));

                if (medicine.id == 0) {
                  return const SizedBox.shrink();
                } else {
                  return itemList(
                      context: context, fun: () => close(context, medicine), isTablet: isTablet, medicine: medicine);
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> search = searchExemple.map<Map<String, dynamic>>((value) {
      return {
        'id': value.id,
        'nome': value.name,
        'concentracao': value.concentration,
        'forma_farmaceutica': value.pharmaceuticalForm,
        'detentor': value.detentor,
        'principio_ativo': value.medicine.principlesActives,
      };
    }).toList();

    List<Map<String, dynamic>> resultSearch = search.where((item) {
      bool isExistsName = item['nome'].toLowerCase().contains(query.toLowerCase());
      bool isExistsConcentration = item['concentracao'].toLowerCase().contains(query.toLowerCase());
      bool isExistsPharmaceuticalForm = item['forma_farmaceutica'].toLowerCase().contains(query.toLowerCase());
      bool isExistsDetentor = item['detentor'].toLowerCase().contains(query.toLowerCase());
      bool isExistsPrincipleActive = (item['principio_ativo'] as List<PrinciplesActivesDto>)
          .any((active) => active.name.toLowerCase().contains(query.toLowerCase()));

      return isExistsName ||
          isExistsConcentration ||
          isExistsPharmaceuticalForm ||
          isExistsDetentor ||
          isExistsPrincipleActive;
    }).toList();

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
        bottom: false,
        child: Stack(children: [
          if (!isKeyboardOpen)
            Stack(children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.rotate(
                      angle: 3.14,
                      child: ClipPath(
                          clipper: MyCustomClipper(waveDeep: 15, waveDeep2: 25),
                          child: Container(height: 75, color: Theme.of(context).primaryColor.withOpacity(.6))))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.rotate(
                      angle: 3.14,
                      child: ClipPath(
                          clipper: MyCustomClipper(waveDeep: 25, waveDeep2: 19),
                          child: Container(height: 75, color: Theme.of(context).primaryColor.withOpacity(.5))))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.rotate(
                      angle: 3.14,
                      child: ClipPath(
                          clipper: MyCustomClipper(waveDeep: 28, waveDeep2: 9),
                          child: Container(height: 70, color: Theme.of(context).primaryColor.withOpacity(.6)))))
            ]),
          ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: resultSearch.length,
              itemBuilder: (BuildContext context, index) {
                var medicine = searchExemple.firstWhere((item) => item.id == resultSearch[index]['id'],
                    orElse: () => MedicinePresentation(
                          concentration: '',
                          detentor: '',
                          pharmaceuticalForm: '',
                          id: 0,
                          name: '',
                          url: '',
                          medicine:
                              MedicineDto(principlesActives: [], id: 0, url: '', name: '', ingredientsActiveAnvisa: []),
                        ));

                if (medicine.id == 0) {
                  return const SizedBox.shrink();
                } else {
                  return itemList(
                      context: context, fun: () => close(context, medicine), medicine: medicine, isTablet: isTablet);
                }
              }),
        ]));
  }
}
