import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/screens/home/components/modal_options.dart';
import 'package:meditrack/screens/home/state.dart';

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
        itemCount: widget.state.list?.length ?? 0,
        itemBuilder: (context, index) {
          final children = widget.state.list![index];
          return Container(
            margin: widget.isTablet
                ? const EdgeInsets.only(left: 28, right: 28, top: 4, bottom: 8)
                : const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12.0),
                border: Border(left: BorderSide(color: Theme.of(context).primaryColor, width: 4.0)),
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
                  await ShowModalOptions().modalViewOptions(children, context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Row(
                    children: [
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
                              // Row(children: [
                              //   const SizedBox(width: 8),
                              //   true
                              //       ? const Icon(Icons.cloud_done, size: 16, color: Colors.lightBlueAccent)
                              //       : const Icon(Icons.cloud_sync, color: Colors.redAccent, size: 16)
                              // ])
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
                            await ShowModalOptions().modalViewOptions(children, context);
                          },
                          icon: const Icon(
                            Icons.restore,
                            size: 32,
                            color: Colors.redAccent,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
