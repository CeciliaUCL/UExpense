import 'package:flutter/material.dart';



class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // 修改后退箭头颜色为白色
        ),
        title: Text('Sign up'),
        backgroundColor:   Color.fromARGB(255, 51, 126, 111),
        foregroundColor: Colors.white ,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color:   Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color:  Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock, color:  Color.fromARGB(255, 51, 126, 111)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor:   Color.fromARGB(255, 51, 126, 111),
                foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('Sign up'),
                
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Already have account？Log in here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
