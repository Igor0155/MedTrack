import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';
import 'package:meditrack/main.dart';

final themeModeAppProvider = StateNotifierProvider<ThemeModeAppState, ThemeModeApp>((ref) => ThemeModeAppState());

class ThemeModeApp {
  final ThemeMode mode;

  ThemeModeApp({required this.mode});
}

class ThemeModeAppState extends StateNotifier<ThemeModeApp> {
  ThemeModeAppState() : super(ThemeModeApp(mode: ThemeMode.light));
  final _clientShared = getIt.get<IClientSharedPreferences>();

  Future<void> init() async {
    var theme = await _clientShared.get('ThemeMode');
    state = ThemeModeApp(mode: (theme ?? '') == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setModeDark(bool isDark) async {
    if (isDark) {
      state = ThemeModeApp(mode: ThemeMode.dark);
      await _clientShared.set("ThemeMode", ThemeMode.dark.toString());
    } else {
      state = ThemeModeApp(mode: ThemeMode.light);
      await _clientShared.set("ThemeMode", ThemeMode.light.toString());
    }
  }

  bool viewMode() {
    return state.mode == ThemeMode.dark;
  }
}
