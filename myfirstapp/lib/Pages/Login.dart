import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uexpense/Pages/Dashboard.dart';
import 'package:uexpense/Pages/SignupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uexpense/utils/utils_logger.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Attempt to sign in using email and password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 51, 126, 111), // Themed AppBar color
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
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 51, 126, 111), width: 2.0),
                  ),
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
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 51, 126, 111), width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 51, 126, 111),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5, // Add shadow for depth
                ),
                onPressed: () => _login(context),
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: const Text('No account？Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle login process
  _login(BuildContext context) {
    _submitData().then((value) {
      if (value) {
        
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        _showLoginError(context, 'Login failed. Please check your email/password and try again.');
      }
    }).catchError((e) {
      _showLoginError(context, 'An error occurred: ${e.toString()}');
      LoggerUtils.e(e);
    });
  }

  // Show login error dialog
  void _showLoginError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Submit email and password for Firebase authentication
  Future<bool> _submitData() async {
    try {
      var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      LoggerUtils.i("_signIn result:$res");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        LoggerUtils.e('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        LoggerUtils.e('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      LoggerUtils.e(e);
      return false;
    }
  }
}
