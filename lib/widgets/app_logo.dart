import 'package:flutter/material.dart';

// Reusable app logo used on the splash and login screens.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 88});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        // Material 3 colors automatically adapt to light and dark themes.
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.bolt_rounded,
        color: colorScheme.onPrimaryContainer,
        size: size * 0.56,
      ),
    );
  }
}
