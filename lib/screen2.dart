import 'package:material_ui/material_ui.dart';
import 'screen2_1.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final TextEditingController _searchController = TextEditingController();

  // Student dataset using clean type inference
  final _allStudents = [
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

  // Filter students using simple type inference list return type to avoid bracket parsing bugs
  List _getFilteredStudents(String programme) {
    return _allStudents.where((student) {
      final matchesProgramme =
          programme == 'All' || student['programme'] == programme;
      final query = _searchController.text;
      final matchesSearch =
          student['name']!.toLowerCase().contains(query.toLowerCase()) ||
              student['id']!.contains(query);
      return matchesProgramme && matchesSearch;
    }).toList();
  }

  // Helper color for programme badges using modern .withValues()
  Color _getProgrammeColor(String? programme) {
    switch (programme) {
      case 'Software Engineering':
        return Colors.blue.shade700;
      case 'Data Networking':
        return Colors.teal.shade700;
      case 'Computer Science':
        return Colors.deepPurple.shade700;
      default:
        return Colors.blueGrey;
    }
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
        backgroundColor: Colors.grey[550],
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Student Directory',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: programmes.map((prog) => Tab(text: prog)).toList(),
          ),
        ),
        body: Column(
          children: [
            // Styled Search Bar Container
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by name or matric number',
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            // TabBarView to display list views filtered by tabs
            Expanded(
              child: TabBarView(
                children: programmes.map((prog) {
                  final students = _getFilteredStudents(prog);
                  if (students.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'No students found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index] as Map;
                      final progName = student['programme'] as String?;
                      final badgeColor = _getProgrammeColor(progName);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StudentDetailPage(student: student),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Profile Avatar
                                  CircleAvatar(
                                    backgroundColor: badgeColor.withValues(alpha: 0.12),
                                    radius: 26,
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: badgeColor,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Student Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student['name']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Matric No: ${student['id']}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Programme Badge Tag
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: badgeColor.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            progName ?? '',
                                            style: TextStyle(
                                              color: badgeColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Chevron Arrow
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          ),
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