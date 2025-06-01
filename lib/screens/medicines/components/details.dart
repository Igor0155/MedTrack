import 'package:flutter/material.dart';
import 'package:meditrack/screens/home/components/widget_label_and_content.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/shared/types/medicine_presentation.dart';

class DetailsMedicinePresentation {
  final detailsContent = WidgetLabelAndContent();
  MedicinePresentation medicine;

  DetailsMedicinePresentation({required this.medicine});

  Future<void> detailsMedicineModal(BuildContext context) async {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      enableDrag: false,
      useSafeArea: true,
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                                label: 'Nome',
                                content: medicine.name.isNotEmpty
                                    ? '${medicine.name[0].toUpperCase()}${medicine.name.substring(1).toLowerCase()}'
                                    : '',
                                isNotTextOverflowEllipsis: true),
                            detailsContent.widget(
                                label: 'Forma farmacêutica',
                                content: medicine.pharmaceuticalForm,
                                isNotTextOverflowEllipsis: true),
                            detailsContent.widget(
                                label: 'Concentração do medicamento',
                                content: medicine.concentration,
                                isNotTextOverflowEllipsis: true),
                            detailsContent.widget(
                                label: 'Detentor', content: medicine.detentor, isNotTextOverflowEllipsis: true),
                            detailsContent.widget(
                                label: 'Principais ativos ANVISA',
                                content: medicine.medicine.ingredientsActiveAnvisa.map((e) => e).join(', '),
                                isNotTextOverflowEllipsis: true),
                            detailsContent.widget(
                                label: 'Principais ativos',
                                content: medicine.medicine.principlesActives.map((e) => e.name).join(', '),
                                isNotTextOverflowEllipsis: true),
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
      },
    );
  }
}
