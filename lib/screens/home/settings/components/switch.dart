import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/shared/stores/theme_mode_app.dart';

class SwitchMode extends ConsumerStatefulWidget {
  const SwitchMode({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SwitchModeState();
}

class _SwitchModeState extends ConsumerState<SwitchMode> {
  @override
  Widget build(BuildContext context) {
    var setThemeMode = ref.watch(themeModeAppProvider.notifier);
    var viewThemeMode = ref.watch(themeModeAppProvider);
    return Transform.scale(
      scale: 0.80,
      alignment: Alignment.centerRight,
      child: Switch(
        value: viewThemeMode.mode == ThemeMode.dark,
        onChanged: (isDark) async {
          await setThemeMode.setModeDark(isDark);
        },
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveThumbColor: const Color(0xfffbbf24),
        inactiveTrackColor: const Color(0xfffde68a).withOpacity(.68),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.transparent;
          }
          return Colors.black26;
        }),
        trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return 0.48;
          }
          return 0.48;
        }),
        thumbIcon: WidgetStateProperty.resolveWith<Icon>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.dark_mode, color: Colors.white);
            }
            return const Icon(Icons.light_mode, color: Colors.white);
          },
        ),
      ),
    );
  }
}
