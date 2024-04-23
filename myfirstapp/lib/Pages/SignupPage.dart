import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uexpense/Pages/Dashboard.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  // Controllers for text input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Animation controller to control transition effects
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;  // For fading the entire form in
  Animation<Offset>? _slideAnimation;     // For sliding text fields into view
  Animation<double>? _buttonScaleAnimation; // For button press animation

  @override
  void initState() {
    super.initState();
    // Initializing the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Defining the opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    // Defining the slide animation for text fields
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    // Defining the scale animation for the button
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller to avoid memory leaks
    _animationController?.dispose();
    super.dispose();
  }

  // Function to handle user registration
  Future<void> registerWithEmailPassword(BuildContext context, String email, String password, String confirmPassword) async {
    // Check if passwords match before proceeding
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
          child: FadeTransition(
            opacity: _opacityAnimation!,
            child: SlideTransition(
              position: _slideAnimation!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 51, 126, 111)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 76, 175, 80), width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 51, 126, 111)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 76, 175, 80), width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 51, 126, 111)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 76, 175, 80), width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTapDown: (_) => _animationController!.reverse(),
                    onTapUp: (_) => _animationController!.forward(),
                    onTapCancel: () => _animationController!.forward(),
                    child: ScaleTransition(
                      scale: _buttonScaleAnimation!,
                      child: ElevatedButton(
                        onPressed: () => registerWithEmailPassword(context, emailController.text, passwordController.text, confirmPasswordController.text),
                        child: Text('Sign up'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 51, 126, 111),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
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
        ),
      ),
    );
  }

  // Function to display dialog for registration errors or success
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
                Navigator.of(context). pop();
              },
            ),
          ],
        );
      },
    );
  }
}
