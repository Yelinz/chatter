import 'package:chatter/screens/course_overview_page.dart';
import 'package:chatter/screens/settings_page.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget _selectedPage = const CourseOverviewPage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        _selectedPage = const CourseOverviewPage();
      } else if (index == 1) {
        _selectedPage = const ChatPage();
      } else if (index == 2) {
        _selectedPage = const SettingsPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _selectedPage,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dataset),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF642B73),
          onTap: _onItemTapped,
        ));
  }
}
