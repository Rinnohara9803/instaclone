import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/colors_manager.dart';

class SnackBars {
  static void showNormalSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(
          milliseconds: 2000,
        ),
        backgroundColor: Colors.black12,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
        duration: const Duration(
          milliseconds: 2000,
        ),
      ),
    );
  }

  static void showNoInternetConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No internet connection.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(
          milliseconds: 2000,
        ),
        backgroundColor: Colors.black12,
      ),
    );
  }
}
