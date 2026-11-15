import 'package:material_ui/material_ui.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'About',
        style: TextStyle(
          fontSize: 50,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
