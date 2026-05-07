import 'package:flutter_test/flutter_test.dart';
import 'package:swiftpay/main.dart';

void main() {
  testWidgets('SwiftPay starts with splash screen', (tester) async {
    await tester.pumpWidget(const SwiftPayApp());

    expect(find.text('SwiftPay'), findsOneWidget);
    expect(find.text('Fast UPI payments for everyone'), findsOneWidget);
  });
}
