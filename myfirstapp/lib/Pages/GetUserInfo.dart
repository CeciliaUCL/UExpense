import 'package:firebase_auth/firebase_auth.dart';

String getUserSig() {
  User? user = FirebaseAuth.instance.currentUser; // curUser
  return user!.email.toString();
}

// String getUserSig() {
//   return "test@test.com";
// }
