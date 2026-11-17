import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'about.dart';
import 'navigation_provider.dart';
import 'screen1.dart';
import 'screen2.dart';
import 'screen3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const _StudentHubPage(),
      ),
    );
  }
}

class _StudentHubPage extends StatelessWidget {
  const _StudentHubPage();

  static const List<Widget> _tabs = [
    Screen1(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

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
      // Only the changing body and navigation bar subscribe to the index.
      body: Selector<NavigationProvider, int>(
        selector: (_, navigation) => navigation.currentIndex,
        builder: (_, currentIndex, _) =>
            IndexedStack(index: currentIndex, children: _tabs),
      ),
      bottomNavigationBar: Selector<NavigationProvider, int>(
        selector: (_, navigation) => navigation.currentIndex,
        builder: (_, currentIndex, _) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 19.0,
          unselectedFontSize: 14.0,
          iconSize: 30.0,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded),
              label: 'View Students',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_rounded),
              label: 'Student Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_rounded),
              label: 'About',
            ),
          ],
          onTap: context.read<NavigationProvider>().selectTab,
        ),
      ),
    );
  }
}
