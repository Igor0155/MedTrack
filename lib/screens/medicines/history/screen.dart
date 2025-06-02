import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/medicines/history/components/details_medicine.dart';
import 'package:meditrack/screens/medicines/history/components/item_list_medicine.dart';
import 'package:meditrack/screens/medicines/history/state.dart';
import 'package:meditrack/shared/custom_clipper/bottom_clipper.dart';
import 'package:meditrack/shared/components/med_appbar.dart';
import 'package:meditrack/shared/components/no_data.dart';
import 'package:meditrack/shared/components/snackbar_message.dart';
import 'package:meditrack/shared/components/warning.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/exception_type.dart';
import 'package:go_router/go_router.dart';

class HistoryMedicamentsScreen extends StatefulWidget {
  const HistoryMedicamentsScreen({super.key});

  @override
  State<HistoryMedicamentsScreen> createState() => _HistoryMedicamentsScreenState();
}

class _HistoryMedicamentsScreenState extends State<HistoryMedicamentsScreen> {
  final state = StateHistoryMedicine(clientMedicine: getIt.get<DioClientMedicine>());
  final isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');

  @override
  void initState() {
    scheduleMicrotask(() async {
      try {
        if (mounted) await state.loadingMedicine();
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
        title: 'Histórico de Medicamento',
        leading:
            IconButton(padding: EdgeInsets.zero, onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
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
                  } else if (state.medicines?.isEmpty ?? false) {
                    return noData(
                        icon: 'empty-data', iconSize: 100, label: 'Não há nenhuma apresentação dos medicamentos');
                  } else if (state.medException) {
                    return warning(label: state.medExceptionMessage, fun: () async => await state.loadingMedicine());
                  }
                  return Column(
                    children: [
                      Expanded(
                          child: RefreshIndicator(
                        backgroundColor: Colors.white,
                        onRefresh: () async => await state.loadingMedicine(),
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.medicines!.length,
                            itemBuilder: (BuildContext context, index) {
                              final medicine = state.medicines![index];
                              return itemListMedicine(
                                medicine: medicine,
                                isTablet: isTablet,
                                context: context,
                                fun: () => DetailsMedicineMedicine(medicine: medicine).detailsMedicineModal(context),
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
