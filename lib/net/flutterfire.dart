import 'package:cloud_firestore/cloud_firestore.dart';
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

Future<bool> addCoin(String id, String amount) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    double value = double.parse(amount);
    DocumentReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('coins')
        .doc(id);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        ref.set({'amount': value});
        return true;
      }
      var data = snapshot.data() as Map<String, dynamic>;
      double newAmount = double.parse(data['amount']) + value;
      transaction.update(ref, {'amount': newAmount});
      return true;
    });
  } catch (e) {
    print(e.toString());
    return false;
  }
}
