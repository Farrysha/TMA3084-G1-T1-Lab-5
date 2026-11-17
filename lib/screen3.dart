import 'package:material_ui/material_ui.dart';

/// One row of the records table.
///
/// Replaces `Map<String, dynamic>`. The old map meant `_sort` compared
/// `dynamic` values (`a[key].compareTo(b[key])`) and the cells passed
/// `dynamic` into `Text`'s `String` parameter, so a misspelled key or a
/// missing field was a runtime crash instead of a compile error.
class _StudentRecord {
  const _StudentRecord({
    required this.name,
    required this.id,
    required this.programme,
    required this.cgpa,
  });

  final String name;
  final String id;
  final String programme;
  final double cgpa;
}

/// The sortable columns, in the order they are displayed.
///
/// Holding the label, the cell text and the comparison together means the
/// column index, the header and the sort key cannot fall out of step.
enum _Column {
  name('Name'),
  id('Matric No'), // was "Matrix No"
  programme('Programme'),
  cgpa('CGPA', numeric: true);

  const _Column(this.label, {this.numeric = false});

  final String label;
  final bool numeric;

  /// The text shown in this column's cell.
  String cell(_StudentRecord student) => switch (this) {
    _Column.name => student.name,
    _Column.id => student.id,
    _Column.programme => student.programme,
    _Column.cgpa => student.cgpa.toStringAsFixed(2),
  };

  /// Compares two records on this column, ascending. Typed, so the compiler
  /// checks every column is handled.
  int compare(_StudentRecord a, _StudentRecord b) => switch (this) {
    _Column.name => a.name.compareTo(b.name),
    _Column.id => a.id.compareTo(b.id),
    _Column.programme => a.programme.compareTo(b.programme),
    _Column.cgpa => a.cgpa.compareTo(b.cgpa),
  };
}

// First 6 are from Screen 2 (with CGPA added), last 5 are new.
const List<_StudentRecord> _seedRecords = [
  _StudentRecord(
    name: 'Siti Elisya',
    id: '103103',
    programme: 'Software Engineering',
    cgpa: 3.85,
  ),
  // Was 'John Doe' here while screen2.dart has 'Muhammad Amin' for the same
  // matric number. The first six rows are copied from Screen 2, so Screen 2
  // is the source of truth.
  _StudentRecord(
    name: 'Muhammad Amin',
    id: '102142',
    programme: 'Data Networking',
    cgpa: 3.40,
  ),
  _StudentRecord(
    name: 'Sarah Lee',
    id: '104859',
    programme: 'Computer Science',
    cgpa: 3.70,
  ),
  _StudentRecord(
    name: 'Jane Doe',
    id: '101938',
    programme: 'Software Engineering',
    cgpa: 3.25,
  ),
  _StudentRecord(
    name: 'Kenny Emmet',
    id: '105221',
    programme: 'Data Networking',
    cgpa: 3.10,
  ),
  _StudentRecord(
    name: 'Michael Tan',
    id: '106789',
    programme: 'Computer Science',
    cgpa: 3.55,
  ),
  // 5 new records
  _StudentRecord(
    name: 'Aina Rahman',
    id: '107345',
    programme: 'Software Engineering',
    cgpa: 3.92,
  ),
  _StudentRecord(
    name: 'David Ng',
    id: '108112',
    programme: 'Computer Science',
    cgpa: 2.95,
  ),
  _StudentRecord(
    name: 'Nur Aisyah',
    id: '109476',
    programme: 'Data Networking',
    cgpa: 3.62,
  ),
  _StudentRecord(
    name: 'Ali Tan',
    id: '110230',
    programme: 'Software Engineering',
    cgpa: 3.48,
  ),
  _StudentRecord(
    name: 'Priya Nair',
    id: '111587',
    programme: 'Computer Science',
    cgpa: 3.78,
  ),
];

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  _Column _sortColumn = _Column.name;
  bool _sortAscending = true;

  /// A mutable copy, sorted by name A-Z up front.
  ///
  /// The old code did this in `initState()` by calling `_sort()` without
  /// `setState`, and sorted the list it was given in place. Doing it in the
  /// field initializer removes the lifecycle step, and copying means the
  /// seed data above is never mutated (calling `sort()` on a const list
  /// throws).
  late final List<_StudentRecord> _students = [..._seedRecords]
    ..sort(_sortColumn.compare);

  /// Hoisted out of build(), which allocated a new property object each time.
  static const WidgetStateProperty<Color?> _headingColor =
      WidgetStatePropertyAll(Color(0xFFE3F2FD)); // Colors.blue.shade50

  static const TextStyle _headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  // Called when a column header is tapped.
  void _onSort(_Column column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _sortAscending = ascending;
      _students.sort(
        (a, b) => ascending ? column.compare(a, b) : column.compare(b, a),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          //Sorting arrow on the active column.
          sortColumnIndex: _sortColumn.index,
          sortAscending: _sortAscending,
          headingRowColor: _headingColor,
          columns: [
            for (final column in _Column.values)
              DataColumn(
                label: Text(column.label, style: _headingStyle),
                numeric: column.numeric,
                onSort: (_, ascending) => _onSort(column, ascending),
              ),
          ],
          rows: [
            for (final student in _students)
              DataRow(
                key: ValueKey(student.id),
                cells: [
                  for (final column in _Column.values)
                    DataCell(Text(column.cell(student))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
