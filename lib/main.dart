import 'package:material_ui/material_ui.dart';

import 'about.dart';
import 'screen1.dart';
import 'screen2.dart';
import 'screen3.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of StudentHub.
///
/// Now a StatelessWidget: the selected tab moved down into [_HomeShell], so
/// tapping a tab no longer rebuilds [MaterialApp] (and the theme with it).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'StudentHub',
      debugShowCheckedModeBanner: false,
      home: _HomeShell(),
    );
  }
}

/// Owns the selected tab, the app bar and the bottom navigation bar.
class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 0;

  /// Built once. The old code rebuilt this list inside `build()`, recreating
  /// all four page widgets on every tab change.
  late final List<Widget> _tabs = [
    Screen1(onNavigate: _goToTab),
    const Screen2(),
    const Screen3(),
    const Screen4(),
  ];

  /// Also constant, so the four items are not reallocated on every rebuild.
  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_alt_rounded),
      label: 'View Students',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.table_chart_rounded),
      label: 'Student Records',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.info_rounded), label: 'About'),
  ];

  /// Passed down to [Screen1] so its menu cards can change the tab.
  void _goToTab(int index) {
    if (index == _currentIndex) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Student Hub',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
      // IndexedStack keeps each tab alive, so scroll position and any
      // sorting on the records table survive a tab switch.
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 19.0,
        unselectedFontSize: 14.0,
        iconSize: 30.0,
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: _goToTab,
      ),
    );
  }
}
