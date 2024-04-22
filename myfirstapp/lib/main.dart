import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/Pages/Dashboard.dart';
import 'package:myfirstapp/Pages/Login.dart';
import 'package:myfirstapp/Pages/SignupPage.dart';
import 'package:myfirstapp/Pages/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfirstapp/tool/DBExTool.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await appCheck();
  await DBExTool().init();
  runApp(MyApp());
}

///
/// https://firebase.google.com/docs/app-check/flutter/default-providers?authuser=0&hl=zh
///
Future<void> appCheck() async {
  return await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    appleProvider: AppleProvider.appAttest,
  );
}

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
