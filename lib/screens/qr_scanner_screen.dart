import 'package:flutter/material.dart';

// Dummy QR scanner UI: teaches navigation without adding camera complexity yet.
class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: Center(
                  child: Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded, size: 96),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dummy scanner UI. In a real app, you can later add a camera package after learning permissions.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
