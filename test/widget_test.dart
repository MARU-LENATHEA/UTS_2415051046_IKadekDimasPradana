import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventhub_uts/widgets/student_header_card.dart';
import 'package:eventhub_uts/constants/supabase_constants.dart';

void main() {
  testWidgets('StudentHeaderCard renders student information correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StudentHeaderCard(),
        ),
      ),
    );

    expect(find.text(studentName), findsOneWidget);
    expect(find.text('$studentId • $studentClass'), findsOneWidget);
  });
}
