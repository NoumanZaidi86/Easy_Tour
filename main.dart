import 'package:easytour/admin_panel/admin_page.dart';

import 'package:easytour/configuration/splash_screen.dart';

import 'package:easytour/homepage.dart';

import 'package:easytour/travel_agent/TravelAgentHomePage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const splashDuration = Duration(seconds: 3);
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        'customers': (context) => HomePage(),
        'travelagents': (context) => TravelAgentHomePage(),
        'admins': (context) => AdminPage(),
      },
    );
  }
}
