import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/models/user.dart';
import 'presentation/screens/login_page.dart';
import 'presentation/screens/home_page.dart'; // O el que sea tu página principal

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialPage = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = User.fromJson(userMap);

      setState(() {
        _initialPage = HomePage(
          login: user.id,
          name: user.name,
          applications: user.applications,
        );
      });
    } else {
      setState(() {
        _initialPage = const LoginPage();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login SIGAH ANALYTICS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Center(child: _initialPage),
      ),
    );
  }
}

