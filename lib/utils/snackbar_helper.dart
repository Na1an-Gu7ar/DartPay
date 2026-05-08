import 'package:flutter/material.dart';

// A helper keeps snackbar styling consistent across the app.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
