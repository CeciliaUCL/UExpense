import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/Pages/Dashboard.dart';
import 'package:myfirstapp/Pages/SignupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/utils/utils_logger.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 51, 126, 111),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController, //email controller
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email,
                      color: Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock,
                      color: Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              //
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 51, 126, 111),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Login successfully
                  _login(context);
                },
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

  _login(BuildContext context) {
    _submitData().then((value) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => Dashboard()),
      );
    }).catchError((e) {
      LoggerUtils.e(e);
    });
  }

  Future<void> _submitData() async {
    try {
      var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        //调用firebase的signInWithEmailAndPassword函数
        email: emailController.text.trim(), //获取用户输入的email
        password: passwordController.text.trim(), //获取用户输入的password
      );
      LoggerUtils.i("_signIn result:$res");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        LoggerUtils.e('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        LoggerUtils.e('The account already exists for that email.');
      }
    } catch (e) {
      LoggerUtils.e(e);
    }
  }
}
