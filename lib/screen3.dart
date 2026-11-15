import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  // Student records: first 6 are from Screen 2 (with CGPA added), last 5 are new.
  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Siti Elisya',
      'id': '103103',
      'programme': 'Software Engineering',
      'cgpa': 3.85,
    },
    {
      'name': 'John Doe',
      'id': '102142',
      'programme': 'Data Networking',
      'cgpa': 3.40,
    },
    {
      'name': 'Sarah Lee',
      'id': '104859',
      'programme': 'Computer Science',
      'cgpa': 3.70,
    },
    {
      'name': 'Jane Doe',
      'id': '101938',
      'programme': 'Software Engineering',
      'cgpa': 3.25,
    },
    {
      'name': 'Kenny Emmet',
      'id': '105221',
      'programme': 'Data Networking',
      'cgpa': 3.10,
    },
    {
      'name': 'Michael Tan',
      'id': '106789',
      'programme': 'Computer Science',
      'cgpa': 3.55,
    },
    // 5 new records
    {
      'name': 'Aina Rahman',
      'id': '107345',
      'programme': 'Software Engineering',
      'cgpa': 3.92,
    },
    {
      'name': 'David Ng',
      'id': '108112',
      'programme': 'Computer Science',
      'cgpa': 2.95,
    },
    {
      'name': 'Nur Aisyah',
      'id': '109476',
      'programme': 'Data Networking',
      'cgpa': 3.62,
    },
    {
      'name': 'Ali Tan',
      'id': '110230',
      'programme': 'Software Engineering',
      'cgpa': 3.48,
    },
    {
      'name': 'Priya Nair',
      'id': '111587',
      'programme': 'Computer Science',
      'cgpa': 3.78,
    },
  ];

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _sort('name', true); // A-Z
  }

  // Sort the list.
  void _sort(String key, bool ascending) {
    _students.sort((a, b) {
      final result = a[key].compareTo(b[key]);
      return ascending ? result : -result;
    });
  }

  // Called when a column header is tapped.
  void _onSort(int columnIndex, String key, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sort(key, ascending);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          
          // Sorting arrow on the active column.
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
          columns: [
            DataColumn(
              label: const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (i, asc) => _onSort(i, 'name', asc),
            ),
            DataColumn(
              label: const Text(
                'Matrix No',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (i, asc) => _onSort(i, 'id', asc),
            ),
            DataColumn(
              label: const Text(
                'Programme',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (i, asc) => _onSort(i, 'programme', asc),
            ),
            DataColumn(
              label: const Text(
                'CGPA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
              onSort: (i, asc) => _onSort(i, 'cgpa', asc),
            ),
          ],
          rows: _students.map((s) {
            return DataRow(
              cells: [
                DataCell(Text(s['name'])),
                DataCell(Text(s['id'])),
                DataCell(Text(s['programme'])),
                DataCell(Text(s['cgpa'].toStringAsFixed(2))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
