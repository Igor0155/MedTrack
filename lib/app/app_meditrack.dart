import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditrack/shared/stores/theme_mode_app.dart';
import 'package:meditrack/theme/theme.dart';
import 'package:meditrack/router/router.dart';

class MediTrack extends ConsumerStatefulWidget {
  const MediTrack({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediTrackState();
}

class _MediTrackState extends ConsumerState<MediTrack> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeAppProvider);
    final MaterialTheme materialTheme = MaterialTheme(GoogleFonts.openSansTextTheme());
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      themeMode: themeMode.mode,
      theme: materialTheme.light,
      darkTheme: materialTheme.dark,
      routerConfig: router,
    );
  }
}
