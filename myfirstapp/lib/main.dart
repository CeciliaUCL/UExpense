import 'package:flutter/material.dart';
import 'package:myfirstapp/Pages/Dashboard.dart';
import 'package:myfirstapp/Pages/Login.dart';
import 'package:myfirstapp/Pages/SignupPage.dart';
import 'package:myfirstapp/Pages/WelcomePage.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UExpense',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: WelcomePage(), // Set welcome page
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}
