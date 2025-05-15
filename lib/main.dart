import 'package:flutter/material.dart';
import 'package:mchat/pages/bottomnav.dart';
import 'package:mchat/pages/chats_page.dart';
import 'package:mchat/pages/chatting_page.dart';
import 'package:mchat/pages/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mchat",
      home: ChattingPage(),
    );
  }
}
