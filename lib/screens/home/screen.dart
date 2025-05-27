import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/home/components/drawer/screen.dart';
import 'package:meditrack/screens/home/components/listview_medicament.dart';
import 'package:meditrack/screens/home/state.dart';
import 'package:meditrack/shared/components/med_appbar.dart';
import 'package:meditrack/shared/components/no_data.dart';

class HomeApp extends ConsumerStatefulWidget {
  const HomeApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAppState();
}

class _HomeAppState extends ConsumerState<HomeApp> {
  late bool isTablet;
  var isItemCount = false;

  final state = MedicamentStateNotifier();

  @override
  void initState() {
    isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');
    super.initState();
  }

  Future<void> refresh() async {
    // await state.refreshNavigate(
    //   authState.infoToken!.fsRoot!.cuid,
    //   ref.watch(inputSearchItems.notifier).compareState(),
    // );
  }

  void changeItemCount({required bool isShowCountItems}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && isItemCount != isShowCountItems) {
        setState(() {
          isItemCount = isShowCountItems;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: medAppBar(
          scrolledUnderElevation: 0,
          title: 'MedTrack',
        ),
        drawer: const HomeDrawer(),
        body: SafeArea(
          child: ListenableBuilder(
              listenable: state,
              builder: (context, _) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (state.list.isEmpty && state.isLoading)
                        Center(
                          child: Column(
                            children: [
                              LinearProgressIndicator(color: Theme.of(context).primaryColor),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text("Carregando..."))
                            ],
                          ),
                        ),
                      Expanded(
                        child: Stack(children: [
                          Builder(builder: (context) {
                            if (state.list.isEmpty && state.isLoading) {
                              changeItemCount(isShowCountItems: false);
                              return const Center(child: CircularProgressIndicator());
                            } else if (state.isMedException) {
                              changeItemCount(isShowCountItems: false);
                              return const SizedBox(); //warning(label: state.gedocsExceptionMessage, fun: () async {});
                            } else if (state.list.isEmpty) {
                              changeItemCount(isShowCountItems: false);
                              return noData(icon: 'empty');
                            }
                            changeItemCount(isShowCountItems: true);
                            return Column(children: [
                              Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 10),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // selectLayout(
                                      //   context: context,
                                      //   selected: <SelectedView>{selectedView},
                                      //   onSelectionChanged: (Set<SelectedView> newSelection) {
                                      //     ref.read(viewWorkspace.notifier).changeView(newSelection.first);
                                      //   },
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: RefreshIndicator.adaptive(
                                      backgroundColor: Colors.white,
                                      color: Theme.of(context).primaryColor,
                                      onRefresh: refresh,
                                      child: ListViewMedicament(state: state, isTablet: isTablet))),
                            ]);
                          }),
                          if (isItemCount)
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, bottom: 10),
                                child: Align(
                                    alignment: AlignmentDirectional.bottomStart,
                                    child: Container(
                                        margin: const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                                            color: Theme.of(context).colorScheme.outline,
                                            borderRadius: const BorderRadius.all(Radius.circular(5))),
                                        height: 20,
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                              '${state.list.length}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.black),
                                            )))),
                              ),
                            ),
                          // if (state.isLoadingFromOpenFile)
                          //   Container(
                          //       width: double.infinity,
                          //       height: MediaQuery.of(context).size.height,
                          //       color: Colors.black26,
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           const CircularProgressIndicator.adaptive(),
                          //           const SizedBox(height: 10),
                          //           D3ElevatedButton.primary(
                          //             label: 'Cancelar',
                          //             onPressed: () {
                          //               controller.cancelDownload();
                          //             },
                          //           ),
                          //         ],
                          //       )),
                        ]),
                      ),
                    ],
                  ),
                );
              }),
        ),
        floatingActionButton: SafeArea(
            child: ListenableBuilder(
                listenable: state,
                builder: (context, _) {
                  if (state.isLoading || state.isMedException) {
                    return const SizedBox();
                  } else {
                    return SizedBox(
                      height: 48,
                      child: FloatingActionButton.extended(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          extendedPadding: const EdgeInsets.all(12),
                          onPressed: () async {
                            context.push('/add_medicament');
                            //  var result = await modalFloatActionButton.primaryModal(context, state);
                          },
                          label: const Text('Novo'),
                          icon: const Icon(Icons.add)),
                    );
                  }
                })));
  }
}
