
import 'package:flutter/material.dart';

import '../consts/lang.dart';

class NavigationUtils {
  /// Show an exit confirmation dialog
  static Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(Lang.exitApp),
          content: const Text(Lang.doYouReally),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Dismiss dialog
              child: const Text(Lang.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm exit
              child: const Text(Lang.exit),
            ),
          ],
        );
      },
    ) ??
        false;
  }
  static Future<bool> handleBackNavigation(BuildContext context) async {
    if (!Navigator.of(context).canPop()) {
      return await showExitConfirmationDialog(context);
    }
    return true;
  }
}
