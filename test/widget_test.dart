import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:bottom_navigation_bar_lab/main.dart';
import 'package:bottom_navigation_bar_lab/screen2_1.dart';

/// Taps a destination in the bottom navigation bar by its label.
Future<void> tapNavTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.text(label),
    ),
  );
  await tester.pumpAndSettle();
}

/// The first [count] names in the records table, read from the rendered rows.
List<String> firstNames(DataTable table, int count) {
  return table.rows
      .take(count)
      .map((row) => (row.cells.first.child as Text).data!)
      .toList();
}

void main() {
  group('Navigation shell', () {
    testWidgets('opens on Home with exactly one app bar', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Student Hub'), findsOneWidget);
      expect(find.text('Your Student Portal'), findsOneWidget);
      // Regression check: screen2.dart used to nest its own Scaffold and
      // AppBar inside the shell's body, so two headers were stacked.
      expect(find.byType(AppBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a Quick Access card switches tab, not route', (tester) async {
      await tester.pumpWidget(const MyApp());

      final card = find.text('Sortable table of names and CGPA');
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 2);
      // The bar must still be on screen: the card changes the index rather
      // than pushing a route over it.
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });

  group('About tab', () {
    testWidgets('shows course and developer information', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'About');

      expect(
        find.text('Your Student Information, Simplified.'),
        findsOneWidget,
      );
      expect(find.text('Version: 1.0.0'), findsOneWidget);
      expect(find.text('Key Features'), findsOneWidget);
      expect(find.text('TMA3084 Group G1-T1'), findsOneWidget);
      expect(find.text('Universiti Malaysia Sarawak (UNIMAS)'), findsOneWidget);
      expect(find.text('App Version 1.0.0'), findsOneWidget);
      expect(find.text('© 2026 StudentHub'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Student list tab', () {
    testWidgets('search filters by name and can be cleared', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'View Students');

      expect(find.text('Siti Elisya'), findsOneWidget);
      // The clear button only appears once there is a query.
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'sarah');
      await tester.pumpAndSettle();

      expect(find.text('Sarah Lee'), findsOneWidget);
      expect(find.text('Siti Elisya'), findsNothing);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('Siti Elisya'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('search also matches a matric number', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'View Students');

      await tester.enterText(find.byType(TextField), '104859');
      await tester.pumpAndSettle();

      expect(find.text('Sarah Lee'), findsOneWidget);
      expect(find.text('Michael Tan'), findsNothing);
    });

    testWidgets('an unmatched query shows the empty state', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'View Students');

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pumpAndSettle();

      expect(find.text('No students found.'), findsOneWidget);
    });

    testWidgets('tapping a student opens the details page', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'View Students');

      await tester.tap(find.text('Sarah Lee'));
      await tester.pumpAndSettle();

      expect(find.text('Student Details'), findsOneWidget);
      final page = tester.widget<StudentDetailPage>(
        find.byType(StudentDetailPage),
      );
      expect(page.student['name'], 'Sarah Lee');
      expect(tester.takeException(), isNull);
    });
  });

  group('Student records tab', () {
    testWidgets('starts sorted by name A-Z', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'Student Records');

      final table = tester.widget<DataTable>(find.byType(DataTable));
      expect(table.sortColumnIndex, 0);
      expect(table.sortAscending, isTrue);
      expect(firstNames(table, 3), ['Aina Rahman', 'Ali Tan', 'David Ng']);
    });

    testWidgets('the header reads Matric No, not Matrix No', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'Student Records');

      expect(find.text('Matric No'), findsOneWidget);
      expect(find.text('Matrix No'), findsNothing);
    });

    testWidgets('matric 102142 matches the student list', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'Student Records');

      final table = tester.widget<DataTable>(find.byType(DataTable));
      final row = table.rows.firstWhere(
        (row) => (row.cells[1].child as Text).data == '102142',
      );
      expect((row.cells.first.child as Text).data, 'Muhammad Amin');
    });

    testWidgets('tapping the CGPA header sorts by CGPA', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tapNavTab(tester, 'Student Records');

      final header = find.text('CGPA');
      await tester.ensureVisible(header);
      await tester.pumpAndSettle();
      await tester.tap(header);
      await tester.pumpAndSettle();

      final table = tester.widget<DataTable>(find.byType(DataTable));
      expect(table.sortColumnIndex, 3);
      expect(table.sortAscending, isTrue);
      // Lowest CGPA (2.95) first.
      expect(firstNames(table, 1), ['David Ng']);
      expect(tester.takeException(), isNull);
    });
  });
}
