import 'package:flutter/material.dart';

extension D3SnackbarMessage on BuildContext {
  Duration get duration => const Duration(seconds: 2);
  bool get showCloseIcon => true;

  showSnackBarSuccess(String message, [Duration duration = const Duration(seconds: 4)]) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        key: const Key('snackBarSuccess'),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        showCloseIcon: showCloseIcon,
        backgroundColor: const Color(0xFF66BB6A),
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }

  showSnackBarError(String message, [Duration duration = const Duration(seconds: 6)]) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(
        key: const Key('snackBarError'),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        showCloseIcon: showCloseIcon,
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        duration: duration * 3,
      ),
    );
  }

  showSnackBarInfo(String message, [Duration duration = const Duration(seconds: 8)]) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(
        key: const Key('snackBarInfo'),
        content: Text(message, style: const TextStyle(color: Colors.black)),
        showCloseIcon: showCloseIcon,
        closeIconColor: Colors.black,
        backgroundColor: const Color(0xffE6F4FF),
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}
