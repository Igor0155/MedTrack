import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/main.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  final isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: isTablet ? 500 : null,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                    accountName: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text("teste", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))),
                    accountEmail: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Text('Cliente: ',
                              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                              overflow: TextOverflow.ellipsis),
                          Expanded(
                              child: Text("verificar se vai ficar",
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                  overflow: TextOverflow.ellipsis))
                        ],
                      ),
                    ),
                    currentAccountPicture: const Text('-'),
                    currentAccountPictureSize: const Size(60, 60),
                    otherAccountsPictures: [
                      IconButton(
                          onPressed: () async {
                            await context.push('/home/info');
                            setState(() {});
                          },
                          icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary, size: 20)),
                      IconButton(
                          onPressed: () async {
                            // ref.read(authProvider.notifier).logout();
                            // ref.read(inputSearchItems.notifier).cleanSearch();
                            // ref.read(d3CanProvider.notifier).clearAllPermissions();
                            // await service.logout();
                            // if (context.mounted) {
                            //   context.go('/auth_login');
                            // }
                          },
                          icon: Icon(Icons.logout, size: 20, color: Theme.of(context).colorScheme.onPrimary))
                    ],
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary)),
                ExpansionTile(
                    leading: const Icon(Icons.auto_awesome_mosaic_rounded, size: 20),
                    shape: const Border.symmetric(),
                    title: const Text('Espaço'),
                    textColor: Theme.of(context).primaryColor,
                    childrenPadding: const EdgeInsets.only(left: 20),
                    children: [
                      ListTile(
                          leading: const Icon(Icons.dvr_outlined, size: 20),
                          title: const Text('Área de Trabalho'),
                          onTap: () {
                            context.pushReplacement('/home');
                          },
                          minTileHeight: 40),
                      ListTile(
                          leading: const Icon(Icons.delete, size: 20),
                          title: const Text('Lixeira'),
                          onTap: () {
                            // context.go('/home/trash');
                          },
                          minTileHeight: 40),
                    ]),
              ],
            ),
          ],
        ));
  }
}

///order_specials