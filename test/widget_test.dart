import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/main.dart';

void main() {
  testWidgets('NusaTrip berhasil dijalankan', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    expect(find.byType(MyApp), findsOneWidget);
  });
}