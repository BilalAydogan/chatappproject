import 'package:chatapp/ui/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async {
  await Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      user.updateDisplayName(name);
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name,
        "email": email,
        "status": "Unavalible",
        "backImageUrl":
            "https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png",
        "profileImageUrl":
            "https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png",
        "uid": _auth.currentUser!.uid
      });
      return user;
    } else {
      return user;
    }
  } catch (e) {
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  await Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      return user;
    } else {
      return user;
    }
  } catch (e) {
    return null;
  }
}

Future resetPassword(String email) async {
  await Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    return await _auth.sendPasswordResetEmail(email: email);
  } catch (e) {
    return null;
  }
}

Future logOut(BuildContext context) async {
  await Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": "Offline",
    });
    await _auth.signOut().then((user) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  } catch (e) {
    return null;
  }
}
