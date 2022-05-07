// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, must_be_immutable, unused_local_variable

import 'package:chatapp/method/methods.dart';
import 'package:chatapp/method/user.dart';
import 'package:chatapp/ui/editprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserSv _userSv = UserSv();
  ImagePicker picker = ImagePicker();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String? uid = _auth.currentUser!.uid;
    bool image = false;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String backImageUrl = data['backImageUrl'];
          String profileImageUrl = data['profileImageUrl'];
          return Scaffold(
              appBar: AppBar(
                title: Text("Profile"),
                elevation: 8,
                actions: [
                  IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => logOut(context))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => logOut(context),
                child: Icon(Icons.cancel),
                backgroundColor: Colors.red,
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(backImageUrl),
                                fit: BoxFit.cover)),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height / 5,
                            child: Container(
                              alignment: Alignment(0.0, 2.5),
                              child: GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(profileImageUrl),
                                  radius: 60.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        "${data['name']}",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.blueGrey,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        "${data['email']}",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black45,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()),
                            );
                          },
                          child: Text("Edit Profile"))
                    ],
                  ),
                ),
              ));
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
