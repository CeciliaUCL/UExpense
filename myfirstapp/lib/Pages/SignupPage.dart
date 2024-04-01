import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/Pages/Dashboard.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registerWithEmailPassword(BuildContext context, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _showDialog(context, "Error", "Passwords do not match.");
      return;
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _showDialog(context, "Success", "Registration successful!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
    } on FirebaseAuthException catch (e) {
      _showDialog(context, "Registration Error", e.message ?? "An unknown error occurred.");
    } catch (e) {
      _showDialog(context, "Error", "An unexpected error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        backgroundColor: Color.fromARGB(255, 51, 126, 111),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => registerWithEmailPassword(context, emailController.text, passwordController.text, confirmPasswordController.text),
                child: Text('Sign up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 51, 126, 111),
                  foregroundColor: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Already have an account? Log in here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
