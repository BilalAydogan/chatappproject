import 'package:chatapp/ui/home.dart';
import 'package:chatapp/ui/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const Home();
    } else {
      return const LoginScreen();
    }
  }
}
