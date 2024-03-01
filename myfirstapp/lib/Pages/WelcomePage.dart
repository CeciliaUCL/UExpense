import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(flex:1),
            Image.asset('assets/logo.png', width: 120.0, height: 120.0), // 使用项目中的logo
            SizedBox(height: 48.0),
            // extra space
            // login button
            Spacer(flex:1),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 51, 126, 111),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                foregroundColor: Colors.white, 
              ),
              child: Text('Log in', style: TextStyle(fontSize: 16.0)),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            SizedBox(height: 16.0),
           //sign up button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 51, 126, 111),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                foregroundColor: Colors.white, 
              ),
              child: Text('Sign up', style: TextStyle(fontSize: 16.0)),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
          
          ],
        ),
      ),
    );
  }
}
