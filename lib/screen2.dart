import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:material_ui/material_ui.dart';

import 'screen2_1.dart';

/// Student list, filtered by a programme tab and a search query.
///
/// This page is shown as a tab inside main.dart's Scaffold, so it no longer
/// builds a Scaffold and AppBar of its own: that put a second app bar inside
/// the first one's body, and two stacked headers were visible on this tab.
/// The programme TabBar is kept, just without the extra Scaffold around it.
class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final TextEditingController _searchController = TextEditingController();

  /// Hoisted out of build(): the old code allocated this list on every
  /// rebuild, which was on every keystroke.
  static const List<String> _programmes = [
    'All',
    'Software Engineering',
    'Data Networking',
    'Computer Science',
  ];

  // Student datasets
  final List<Map<String, String>> _allStudents = [
    {
      'id': '103103',
      'name': 'Siti Elisya',
      'programme': 'Software Engineering',
    },
    {'id': '102142', 'name': 'Muhammad Amin', 'programme': 'Data Networking'},
    {'id': '104859', 'name': 'Sarah Lee', 'programme': 'Computer Science'},
    {'id': '101938', 'name': 'Jane Doe', 'programme': 'Software Engineering'},
    {'id': '105221', 'name': 'Kenny Emmet', 'programme': 'Data Networking'},
    {'id': '106789', 'name': 'Michael Tan', 'programme': 'Computer Science'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter students based on the active tab's programme and the search query.
  // The query is passed in rather than read from the controller, so this stays
  // a plain function of its inputs.
  List<Map<String, String>> _getFilteredStudents(
    String programme,
    String query,
  ) {
    final needle = query.trim().toLowerCase();
    return _allStudents.where((student) {
      final matchesProgramme =
          programme == 'All' || student['programme'] == programme;
      // `?? ''` instead of `!`: a missing key now yields an empty string
      // rather than throwing.
      final name = student['name'] ?? '';
      final id = student['id'] ?? '';
      final matchesSearch =
          needle.isEmpty ||
          name.toLowerCase().contains(needle) ||
          id.toLowerCase().contains(needle);
      return matchesProgramme && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // No setState anywhere in this screen any more. A TextEditingController is
    // itself a ValueListenable, so the search field and the visible list listen
    // to it directly. The old `onChanged: (_) => setState(() {})` rebuilt this
    // whole subtree on every keystroke and re-filtered all four tab lists.
    return DefaultTabController(
      length: _programmes.length,
      child: Column(
        children: [
          ColoredBox(
            color: Colors.blue,
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [for (final prog in _programmes) Tab(text: prog)],
            ),
          ),
          // Search Bar Widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _SearchField(controller: _searchController),
          ),
          // TabBarView to display list views filtered by tabs
          Expanded(
            child: TabBarView(
              children: [
                for (final prog in _programmes)
                  _ProgrammeList(
                    query: _searchController,
                    filter: (query) => _getFilteredStudents(prog, query),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The search box. Rebuilds itself as the user types, so the clear button can
/// appear and disappear without rebuilding the page above it.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Search by name or matric number',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear search',
                    // No setState needed: clearing the controller notifies
                    // its listeners, which is what rebuilds this field.
                    onPressed: controller.clear,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        );
      },
    );
  }
}

/// One tab's list. The only part of the page that re-filters when the query
/// changes.
class _ProgrammeList extends StatelessWidget {
  const _ProgrammeList({required this.query, required this.filter});

  final ValueListenable<TextEditingValue> query;
  final List<Map<String, String>> Function(String query) filter;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: query,
      builder: (context, value, child) {
        final students = filter(value.text);
        if (students.isEmpty) {
          return const Center(
            child: Text(
              'No students found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: students.length,
          itemBuilder: (context, index) =>
              _StudentCard(student: students[index]),
        );
      },
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student});

  final Map<String, String> student;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        // Profile Icon
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 24,
          child: Icon(Icons.person, color: Colors.white, size: 28),
        ),
        // Student Name
        title: Text(
          student['name'] ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        // Matric Number & Programme
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matric No: ${student['id'] ?? '-'}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Programme: ${student['programme'] ?? '-'}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right, color: Colors.black26),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => StudentDetailPage(student: student),
            ),
          );
        },
      ),
    );
  }
}
