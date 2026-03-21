import 'package:flutter_test/flutter_test.dart';
import 'package:task_management/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskManagementApp());
    expect(find.byType(TaskManagementApp), findsOneWidget);
  });
}
