import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/screens/home/state.dart';
// import 'package:gedocs_app/screens/customer/children/screen.dart';
// import 'package:gedocs_app/screens/customer/components/modal_options.dart';
// import 'package:gedocs_app/screens/customer/file/details/screen.dart';
// import 'package:gedocs_app/screens/customer/file/download/controller.dart';
// import 'package:gedocs_app/screens/customer/folder/screen.dart';
// import 'package:gedocs_app/screens/customer/state.dart';
// import 'package:gedocs_app/screens/customer/stores/selected_items_workspace.dart';
// import 'package:gedocs_app/screens/customer/type.dart';
// import 'package:gedocs_app/shared/components/gedocs_icons.dart';
// import 'package:gedocs_app/shared/helpers/manege_directory_app.dart';
// import 'package:gedocs_app/shared/stores/d3_can.dart';
import 'package:meditrack/theme/utils/app_colors.dart';

class ListViewMedicament extends ConsumerStatefulWidget {
  final MedicamentStateNotifier state;
  final bool isTablet;

  const ListViewMedicament({super.key, required this.state, required this.isTablet});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewWorkspaceState();
}

class _ListViewWorkspaceState extends ConsumerState<ListViewMedicament> {
  @override
  void initState() {
    super.initState();
    // widget.scrollController.addListener(() {
    //   if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent &&
    //       widget.state.info!.children.length < widget.state.info!.totalChildren) {
    //     widget.scrollController.animateTo(widget.scrollController.position.pixels + 50,
    //         duration: const Duration(milliseconds: 50), curve: Curves.easeInOut);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.state.list.length,
        itemBuilder: (context, index) {
          final children = widget.state.list[index];
          return Container(
            margin: widget.isTablet
                ? const EdgeInsets.only(left: 28, right: 28, top: 4, bottom: 8)
                : const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12.0),
                border: Border(
                    left: BorderSide(
                        color: AppColors.greyStrong, // Cor da borda
                        width: 4.0)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1)),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  // try {
                  //   if (selectedItemsProvider.cuids.isEmpty) {
                  //     if (children.type != OutputType.fle) {
                  //       context.push('/home/children',
                  //           extra: ItemScreenProps(cuid: children.cuid, name: children.name));
                  //     } else if (children.type == OutputType.fle &&
                  //         children.fileUploadCompleted &&
                  //         ref.read(d3CanProvider.notifier).access('customer_fs_file', 'download')) {
                  //       widget.state.changeLoadingFileView(true);
                  //       await viewFile.openArchiveFromDirectoryTemp(
                  //           fileName: children.name, fileCuid: children.cuid, controller: widget.controller);
                  //       widget.state.changeLoadingFileView(false);
                  //     } else if (children.type == OutputType.fle &&
                  //         !children.fileUploadCompleted &&
                  //         ref.read(d3CanProvider.notifier).access('customer_fs_file', 'download')) {
                  //       context.showSnackBarInfo(
                  //           'O upload do arquivo ainda não foi concluído.', const Duration(seconds: 4));
                  //     }
                  //   } else {
                  //     if (children.type == OutputType.fle ||
                  //         children.type == OutputType.fld ||
                  //         children.type == OutputType.sdc && !children.isPhysical) {
                  //       if (selectedItemsProvider.cuids.contains(children.cuid)) {
                  //         ref.read(selectedItemsWorkspaceProvider.notifier).removeItem(children.cuid);
                  //       } else {
                  //         ref.read(selectedItemsWorkspaceProvider.notifier).addItem(children.cuid);
                  //       }
                  //     } else {
                  //       context.showSnackBarInfo('Não é possivel selecionar ${children.childrenExtension.description}');
                  //     }
                  //   }
                  // } catch (e) {
                  //   if (!context.mounted) return;
                  //   widget.state.changeLoadingFileView(false);
                  //   context.showSnackBarError(e.toString());
                  // }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.medication,
                          size: 28), //GEDocsIcons.icon(children.childrenExtension.icon, width: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(children.medicineName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(children: [
                              Text(children.medicineName,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              // children.type == OutputType.fle
                              //     ? Row(children: [
                              //         const SizedBox(width: 8),
                              //         children.fileUploadCompleted
                              //             ? const Icon(Icons.cloud_done, size: 16, color: Colors.lightBlueAccent)
                              //             : const Icon(Icons.cloud_sync, color: Colors.redAccent, size: 16)
                              //       ])
                              //     : const SizedBox(),
                            ]),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(children.formaFarm, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            // var result = await ShowModalOptions().modalViewOptions(widget.state, children, context);
                            // if (result == IsFolderOption.rename && context.mounted) {
                            //   var response = await folderOptions.formCreateOrUpdateFolder(
                            //       context: context,
                            //       state: widget.state,
                            //       folderCuid: children.cuid,
                            //       oldName: children.name);
                            //   if (response == true) {
                            //     if (!context.mounted) return;
                            //     context.showSnackBarSuccess('Pasta renomeada com sucesso.');
                            //   }
                            // }
                          },
                          icon: const Icon(Icons.more_vert_rounded))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
