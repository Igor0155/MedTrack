import 'package:flutter/material.dart';
import 'package:meditrack/screens/home/components/widget_label_and_content.dart';
import 'package:meditrack/screens/home/details_medicine/state.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/shared/components/warning.dart';
import 'package:meditrack/shared/helpers/format_date.dart';
import 'package:meditrack/shared/helpers/format_dosage_by_type.dart';
import 'package:go_router/go_router.dart';

class DetailsMedicine {
  final detailsContent = WidgetLabelAndContent();
  final date = FormatDate();
  final state = StateDetailsMedicine();
  String uidMedicine;

  DetailsMedicine({required this.uidMedicine});

  Future<void> detailsMedicineModal(BuildContext context) async {
    state.findMedicine(uidMedicine);
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      enableDrag: false,
      useSafeArea: true,
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ListenableBuilder(
            listenable: state,
            builder: (context, child) {
              if (state.content == null && state.isMedException == false) {
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (state.isMedException) {
                return SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        Row(children: [
                          IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              icon: const Icon(Icons.close)),
                          const Text('Detalhes do Arquivo',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18, color: Color.fromARGB(255, 78, 80, 82))),
                        ]),
                        Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  offset: const Offset(1, 1),
                                  blurRadius: 3,
                                  spreadRadius: 0.1),
                              BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                  spreadRadius: 0.3)
                            ]),
                            child: const Divider(height: 0)),
                        Expanded(
                            child: warning(
                                label: state.medExceptionMessage,
                                fun: () async => await state.findMedicine(uidMedicine))),
                      ]),
                    ),
                  ),
                );
              }

              var content = state.content;
              return SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.pop();
                                },
                                icon: const Icon(Icons.close)),
                            const Text('Detalhes do Medicamento',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                            const SizedBox()
                          ],
                        ),
                        Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3, spreadRadius: 0.1),
                              BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2, spreadRadius: 0.3)
                            ]),
                            child: const Divider(height: 0)),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailsContent.widget(
                                      label: 'Nome', content: content!.medicineName, isNotTextOverflowEllipsis: true),
                                  detailsContent.widget(
                                      label: 'Forma farmacêutica',
                                      content: PharmaceuticalFormEnum.labelFromKey(content.formaFarm) ?? " - ",
                                      isNotTextOverflowEllipsis: true),
                                  detailsContent.widget(
                                      label: 'Dosagem do medicamento',
                                      content: formatDosageByType(dosage: content.dosage, formFarm: content.formaFarm),
                                      isNotTextOverflowEllipsis: true),
                                  detailsContent.widget(
                                      label: 'Intervalo de dosagem',
                                      content: content.dosageIntervalHours > 1
                                          ? '${content.dosageIntervalHours} horas'
                                          : '${content.dosageIntervalHours} hora',
                                      isNotTextOverflowEllipsis: true),
                                  detailsContent.widget(
                                      label: 'Duração do tratamento',
                                      content: content.durationDays > 1
                                          ? '${content.durationDays} dias'
                                          : '${content.durationDays} dia',
                                      isNotTextOverflowEllipsis: true),
                                  detailsContent.widget(
                                      isNotTextOverflowEllipsis: true,
                                      label: 'Data de início do medicamento',
                                      content: content.medicationStartDatetime.isEmpty
                                          ? ' - '
                                          : content.medicationStartDatetime),
                                  detailsContent.widget(
                                      isNotTextOverflowEllipsis: true,
                                      label: 'Observação', //Duração do tratamento
                                      content: content.description.isEmpty ? ' - ' : content.description)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
