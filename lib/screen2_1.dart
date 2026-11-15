import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class StudentDetailPage extends StatelessWidget {
  final Map student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final String name = student['name']?.toString() ?? 'Unknown';
    final String matricNo = student['id']?.toString() ?? '-';
    final String programme = student['programme']?.toString() ?? '-';
    final String email =
        student['email']?.toString() ??
        '${matricNo.toLowerCase()}@student.unimas.my';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Student Details'),
      ),
      body: Padding(
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
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 20),
            _DetailTile(icon: Icons.school, title: 'Programme', value: programme),
            _DetailTile(
              icon: Icons.badge,
              title: 'Matric Number',
              value: matricNo,
            ),
            _DetailTile(icon: Icons.email, title: 'Email', value: email),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy Info'),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: '$name\n$matricNo\n$programme\n$email'),
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student info copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
      subtitle: SelectableText(value),
    );
  }
}
