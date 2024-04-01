import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Color.fromARGB(255, 51, 126, 111),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 51, 126, 111)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 51, 126, 111)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text('Change Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 51, 126, 111),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match!'),
      ));
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String newPassword = _newPasswordController.text.trim();
      await user?.updatePassword(newPassword);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password changed successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to change password: $e'),
      ));
    }
  }
}
