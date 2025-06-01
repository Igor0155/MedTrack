import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/medicines/components/details.dart';
import 'package:meditrack/screens/medicines/components/item_list.dart';
import 'package:meditrack/screens/medicines/components/search.dart';
import 'package:meditrack/screens/medicines/all/state.dart';
import 'package:meditrack/shared/custom_clipper/bottom_clipper.dart';
import 'package:meditrack/shared/components/med_appbar.dart';
import 'package:meditrack/shared/components/no_data.dart';
import 'package:meditrack/shared/components/snackbar_message.dart';
import 'package:meditrack/shared/components/warning.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/exception_type.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/shared/types/medicine_presentation.dart';

class AllMedicamentsScreen extends StatefulWidget {
  const AllMedicamentsScreen({super.key});

  @override
  State<AllMedicamentsScreen> createState() => _AllMedicamentsScreenState();
}

class _AllMedicamentsScreenState extends State<AllMedicamentsScreen> {
  final state = StateSelectMedicine(clientMedicine: getIt.get<DioClientMedicine>());
  final isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');

  @override
  void initState() {
    scheduleMicrotask(() async {
      try {
        if (mounted) await state.searchMedicine();
      } on MedTrackException catch (e) {
        if (mounted) context.showSnackBarError(e.toString());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: medAppBar(
        title: 'Selecione o Medicamento',
        leading:
            IconButton(padding: EdgeInsets.zero, onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  if (state.medicines == null || state.medicines!.results.isEmpty) return;

                  var result = await showSearch(
                      context: context,
                      useRootNavigator: true,
                      delegate: Search(searchExemple: state.medicines!.results, isTablet: isTablet));
                  if (result is MedicinePresentation && context.mounted) {
                    await DetailsMedicinePresentation(medicine: result).detailsMedicineModal(context);
                  }
                } on MedTrackException catch (e) {
                  if (!context.mounted) return;
                  context.showSnackBarError(e.toString());
                }
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SafeArea(
          bottom: false,
          child: Stack(children: [
            bottomClipper(),
            ListenableBuilder(
                listenable: state,
                builder: (context, child) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.medicines?.results.isEmpty ?? false) {
                    return noData(icon: 'empty-data', iconSize: 100, label: 'Não há medicamentos cadastrados');
                  } else if (state.medException) {
                    return warning(label: state.medExceptionMessage, fun: () async => await state.searchMedicine());
                  }
                  return Column(
                    children: [
                      Expanded(
                          child: RefreshIndicator(
                        backgroundColor: Colors.white,
                        onRefresh: () async => await state.searchMedicine(),
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.medicines!.results.length,
                            itemBuilder: (BuildContext context, index) {
                              final medicine = state.medicines!.results[index];
                              return itemList(
                                medicine: medicine,
                                isTablet: isTablet,
                                context: context,
                                fun: () =>
                                    DetailsMedicinePresentation(medicine: medicine).detailsMedicineModal(context),
                              );
                            }),
                      )),
                    ],
                  );
                }),
          ])),
    );
  }
}
