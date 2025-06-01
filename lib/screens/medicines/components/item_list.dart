import 'package:flutter/material.dart';
import 'package:meditrack/shared/types/medicine_presentation.dart';

Widget itemList(
    {required Function()? fun,
    required MedicinePresentation medicine,
    required bool isTablet,
    required BuildContext context}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3)),
      ],
    ),
    margin: isTablet
        ? const EdgeInsets.only(left: 28, right: 28, top: 5, bottom: 9)
        : const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 9),
    child: Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 0.9,
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12.0),
          border: Border(
              left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 5.0),
              right: BorderSide(color: Theme.of(context).colorScheme.primary, width: 5.0)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            if (fun != null) {
              fun();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      medicine.name.isNotEmpty
                          ? '${medicine.name[0].toUpperCase()}${medicine.name.substring(1).toLowerCase()}'
                          : '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Detentor: ${medicine.detentor}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Forma Farmacêutica: ${medicine.pharmaceuticalForm}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4)
                ])),
                const Icon(Icons.chevron_right, size: 28),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
