import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _positionAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and animations
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
    );
    _positionAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller
    _animationController?.dispose();
    super.dispose();
  }

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
            Spacer(flex: 1),
            FadeTransition(
              opacity: _opacityAnimation!,
              child: SlideTransition(
                position: _positionAnimation!,
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/logo.png', width: 120.0, height: 120.0),  // Display the logo
                    SizedBox(height: 24.0),
                    Text(
                      'UExpense',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 126, 111),
                      ),
                      textAlign: TextAlign.center,
                    ), // Display the app name
                    SizedBox(height: 48.0),
                  ],
                ),
              ),
            ),
            Spacer(flex: 1),
            FadeTransition(
              opacity: _opacityAnimation!,
              child: ElevatedButton(
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
              ), // Login button
            ),
            SizedBox(height: 16.0),
            FadeTransition(
              opacity: _opacityAnimation!,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 98, 220, 195),
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
              ), // Sign up button
            ),
          ],
        ),
      ),
    );
  }
}
