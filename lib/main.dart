import 'package:flutter/material.dart';

import 'screen1.dart';
import 'screen2.dart';
import 'screen3.dart';
import 'screen4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  /// Passed down to Screen1 so its menu cards can change tabs.
  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Built inside build() so Screen1 can receive the callback.
    final tabs = <Widget>[
      Screen1(onNavigate: _goToTab),
      Screen2(),
      Screen3(),
      Screen4(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Student Hub',
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
        ),
        // IndexedStack keeps each tab alive, so scroll position and any
        // sorting on the records table survive a tab switch.
        body: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 19.0,
          unselectedFontSize: 14.0,
          iconSize: 30.0,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
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
          onTap: _goToTab,
        ),
      ),
    );
  }
}