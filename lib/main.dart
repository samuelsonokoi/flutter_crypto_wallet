import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:crypto_wallet/authentication.dart';

void main() async {
  // Initialize widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      home: Authentication(),
    );
  }
}
