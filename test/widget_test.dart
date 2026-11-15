import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bottom_navigation_bar_lab/main.dart';

void main() {
  testWidgets('About tab shows course and developer information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Student Hub'), findsOneWidget);
    expect(find.text('Your Student Portal'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('About'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your Student Information, Simplified.'), findsOneWidget);
    expect(find.text('Version: 1.0.0'), findsOneWidget);
    expect(find.text('Key Features'), findsOneWidget);
    expect(find.text('TMA3084 Group G1-T1'), findsOneWidget);
    expect(find.text('Universiti Malaysia Sarawak (UNIMAS)'), findsOneWidget);
    expect(find.text('App Version 1.0.0'), findsOneWidget);
    expect(find.text('© 2026 StudentHub'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}