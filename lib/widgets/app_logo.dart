import 'package:flutter/material.dart';

// Reusable app logo used on auth and splash screens.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 88});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: size,
      width: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: colorScheme.onPrimary,
        size: size * 0.52,
      ),
    );
  }
}
