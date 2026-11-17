import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

//shows a student's details, received a Map from student list
class StudentDetailPage extends StatelessWidget {
  final Map<String, String> student;

  const StudentDetailPage({super.key, required this.student});

  //The map's values are already String, so the old `?.toString()` calls were
  //redundant. The `??` fallbacks are kept: a Map read can legitimately be
  //null when the student list omits a key.
  String get _name => student['name'] ?? 'Unknown';

  String get _matricNo => student['id'] ?? '-';

  String get _programme => student['programme'] ?? '-';

  //placeholder email built from matric number
  String get _email =>
      student['email'] ?? '${_matricNo.toLowerCase()}@student.unimas.my';

  Future<void> _copyInfo(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            'Name: $_name\n'
            'Matric No: $_matricNo\n'
            'Programme: $_programme\n'
            'Email: $_email',
      ),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student info copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Student Details'),
      ),
      //scrollable so the column cannot overflow on a short screen or in
      //landscape, which the old fixed Column could
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              _name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            _DetailTile(
              icon: Icons.school,
              title: 'Programme',
              value: _programme,
            ),
            _DetailTile(
              icon: Icons.badge,
              title: 'Matric Number',
              value: _matricNo,
            ),
            _DetailTile(icon: Icons.email, title: 'Email', value: _email),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy Info'),
              onPressed: () => _copyInfo(context),
            ),
          ],
        ),
      ),
    );
  }
}

//a single row showing an icon, a title and a selectable value
class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      //lets user select and copy the value
      subtitle: SelectableText(value),
    );
  }
}
