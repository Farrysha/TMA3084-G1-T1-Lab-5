import 'package:flutter/material.dart';
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
            Text(matricNo, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Programme'),
              subtitle: Text(programme),
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Matric Number'),
              subtitle: SelectableText(matricNo),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: SelectableText(email),
            ),
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
