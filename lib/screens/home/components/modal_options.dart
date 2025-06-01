import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/screens/home/details_medicine/screen.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/theme/utils/app_colors.dart';

class ShowModalOptions {
  Future<void> modalViewOptions(MedicamentRepositoryFire children, BuildContext context) {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          return Consumer(builder: (context, ref, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: SizedBox(width: 30, child: Divider(thickness: 3, height: 5))),
                    ListTile(
                        enabled: false,
                        title: Text(children.medicineName,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.surfaceContainerHighest),
                            overflow: TextOverflow.clip)),
                    const Divider(),

                    // Opções para aquivo
                    ListTile(
                        onTap: () {
                          // context.push('/update', extra: FileProps(fsFileCuid: children.cuid, state: state));
                          // context.pop();
                        },
                        leading: const Icon(color: null, Icons.drive_file_rename_outline_rounded, size: 20),
                        title: const Text('Editar medicamento', style: TextStyle(fontSize: 14))),
                    ListTile(
                        onTap: () {
                          context.pop();
                          DetailsMedicine(uidMedicine: children.id).detailsMedicineModal(context);
                        },
                        leading: const Icon(color: null, Icons.info_outline, size: 20),
                        title: const Text('Detalhes do medicamento', style: TextStyle(fontSize: 14))),
                    ListTile(
                      onTap: () {
                        // context.push('/home/move-to-trash',
                        //     extra: PropsMoveToTrash(
                        //         cuids: List.of([children.cuid]), state: state, isFle: children.type == OutputType.fle));
                        // context.pop();
                      },
                      leading: Icon(color: AppColors.redError, Icons.delete, size: 20),
                      title: Text(
                        'Deletar medicamento',
                        style: TextStyle(fontSize: 14, color: AppColors.redError, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
