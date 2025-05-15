import 'package:flutter/material.dart';
import 'package:mchat/pages/chats_page.dart';
import 'package:mchat/pages/friends_page.dart';
import 'package:mchat/pages/home_page.dart';
import 'package:mchat/pages/settings_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int currentTabIndex = 2;

  late List pages;
  late HomePage home;
  late FriendsPage friends;
  late ChatsPage chats;
  late SettingsPage settings;
  late Widget currentPage;

  void initState() {
    home = HomePage();
    friends = FriendsPage();
    chats = ChatsPage();
    settings = SettingsPage();
    pages = [home, friends, chats, settings];
    currentPage = ChatsPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade700,
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
