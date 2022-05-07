// ignore_for_file: unnecessary_null_comparison

import 'dart:collection';
import 'dart:io';
import 'package:chatapp/method/usermodel.dart';
import 'package:chatapp/method/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSv {
  UtilsSv uservice = UtilsSv();

  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? UserModel(
            id: snapshot.id,
            name: (snapshot.data() as dynamic)['name'],
            profileImageUrl:
                (snapshot.data() as dynamic)['profileImageUrl'] ?? '',
            backImageUrl: (snapshot.data() as dynamic)['bannerImageUrl'] ?? '',
            email: (snapshot.data() as dynamic)['email'] ?? '',
            status: (snapshot.data() as dynamic)['status'] ?? '')
        : null;
  }

  Stream<UserModel?> getUserInfo(uid) {
    // ignore: unnecessary_cast
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot) as Stream<UserModel?>;
  }

  Future<void> updateProfile(
      File profileImage, File backImage, String name) async {
    String backImageUrl = '';
    String profileImageUrl = '';

    if (backImage != null) {
      backImageUrl = await uservice.uploadFile(backImage,
          'user/profile/${FirebaseAuth.instance.currentUser!.uid}/back');
    }
    if (profileImage != null) {
      profileImageUrl = await uservice.uploadFile(profileImage,
          'user/profile/${FirebaseAuth.instance.currentUser!.uid}/profile');
    }
    Map<String, Object> data = HashMap();
    if (name != '') data['name'] = name;
    if (backImageUrl != '') data['backImageUrl'] = backImageUrl;
    if (profileImageUrl != '') data['profileImageUrl'] = profileImageUrl;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
}
