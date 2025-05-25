import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:meditrack/app/app_meditrack.dart';
import 'package:meditrack/firebase_options.dart';
import 'package:meditrack/shared/helpers/device_type.dart';
import 'package:meditrack/shared/stores/theme_mode_app.dart';

class InitializationWidget extends ConsumerWidget {
  final GetIt getIt;
  const InitializationWidget({super.key, required this.getIt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider do ThemeMode
    final theme = ref.read(themeModeAppProvider.notifier);

    // Registra isTabletDevice no GetIt após inicializar o MaterialApp
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isTabletvalue = isTablet(context);

      getIt.registerSingleton<bool>(isTabletvalue, instanceName: 'isTabletDevice');

      // Inicializando o ThemeMode
      await theme.init();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Inicia o aplicativo principal
      runApp(const ProviderScope(child: MediTrack()));
    });
    return const SizedBox.shrink();
  }
}
