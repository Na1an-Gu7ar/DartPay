import 'package:flutter/material.dart';

// A tiny shimmer-like loading placeholder without adding another package.
class LoadingWidget extends StatefulWidget {
  final String message;

  const LoadingWidget({super.key, this.message = 'Loading...'});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(widget.message),
          ],
        ),
      ),
    );
  }
}
