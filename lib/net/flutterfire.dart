import 'package:firebase_auth/firebase_auth.dart';

// Sign In method
Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

// Sign Up method
Future<bool> signUp(String email, String password) async {
  try {
    // Create an instance of firebase with email and password.
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    // catch firebase specific errors with error codes
    if (e.code == 'weak-password') {
      print('The password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('An account already exists for that email');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
