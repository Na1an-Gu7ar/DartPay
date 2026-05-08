import 'package:flutter_test/flutter_test.dart';
import 'package:DartPay/main.dart';

void main() {
  testWidgets('DartPay starts with splash screen', (tester) async {
    await tester.pumpWidget(const DartPayApp());

    expect(find.text('DartPay'), findsOneWidget);
    expect(find.text('Fast UPI payments for everyone'), findsOneWidget);
  });
}
