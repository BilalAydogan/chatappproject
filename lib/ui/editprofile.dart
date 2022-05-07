// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:chatapp/method/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserSv userSv = UserSv();
  String name = '';
  File? profileImage;
  File? backImage;
  final picker = ImagePicker();

  Future getImage(int type) async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((val) {
      setState(() {
        if (val != null && type == 0) {
          profileImage = File(val.path);
        }
        if (val != null && type == 1) {
          backImage = File(val.path);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile Page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
              child: Column(
            children: [
              TextButton(
                  onPressed: () => getImage(0),
                  child: profileImage == null
                      ? Column(
                          children: [Icon(Icons.person), Text("Profile Image")],
                        )
                      : Image.file(
                          profileImage!,
                          height: 100,
                        )),
              SizedBox(
                height: 75,
              ),
              TextButton(
                  onPressed: () => getImage(1),
                  child: backImage == null
                      ? Column(
                          children: [Icon(Icons.person), Text("Back Image")],
                        )
                      : Image.file(
                          backImage!,
                          height: 100,
                        )),
              TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Username",
                ),
                onChanged: (val) => setState(() {
                  name = val;
                }),
              ),
              SizedBox(
                height: 45,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await userSv.updateProfile(profileImage!, backImage!, name);
                    Navigator.pop(context);
                  },
                  child: Text("Save!"))
            ],
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Back"),
      ),
    );
  }
}
