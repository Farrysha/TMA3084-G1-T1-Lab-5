import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Student dataset
  final _allStudents = [
    {
      'id': '103103',
      'name': 'Siti Elisya',
      'programme': 'Software Engineering',
    },
    {'id': '102142', 'name': 'John Doe', 'programme': 'Data Networking'},
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

  // Filter students based on active tab programme category and search query
  List _getFilteredStudents(String programme) {
    return _allStudents.where((student) {
      final matchesProgramme =
          programme == 'All' || student['programme'] == programme;
      final matchesSearch =
          student['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student['id']!.contains(_searchQuery);
      return matchesProgramme && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final programmes = [
      'All',
      'Software Engineering',
      'Data Networking',
      'Computer Science',
    ];

    return DefaultTabController(
      length: programmes.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student List'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: programmes.map((prog) => Tab(text: prog)).toList(),
          ),
        ),
        body: Column(
          children: [
            // Search Bar Widget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by name or matric number',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            // TabBarView to display list views filtered by tabs
            Expanded(
              child: TabBarView(
                children: programmes.map((prog) {
                  final students = _getFilteredStudents(prog);
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
                    itemBuilder: (context, index) {
                      final student = students[index];
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
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          // Student Name
                          title: Text(
                            student['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          // Matric Number & Programme
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Matric No: ${student['id']}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Programme: ${student['programme']}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            // Navigation to Student Details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StudentDetailPage(student: student),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Minimal Student Details Page stub for navigation connection
class StudentDetailPage extends StatelessWidget {
  final Map student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student['name']} Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Student Details Page for ${student['name']}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
