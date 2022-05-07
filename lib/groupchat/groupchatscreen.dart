// ignore_for_file: prefer_const_constructors

import 'package:chatapp/groupchat/addmember.dart';
import 'package:chatapp/groupchat/groupchatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChatHome extends StatefulWidget {
  const GroupChatHome({Key? key}) : super(key: key);

  @override
  _GroupChatHomeState createState() => _GroupChatHomeState();
}

class _GroupChatHomeState extends State<GroupChatHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = true;
  List groupList = [];
  @override
  void initState() {
    super.initState();
    getAvaliableGroups();
  }

  void getAvaliableGroups() async {
    String uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
      ),
      body: isLoading
          ? SingleChildScrollView(
              child: Container(
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupChatRoom(
                        groupChatId: groupList[index]['id'],
                        groupName: groupList[index]['name'],
                      ),
                    ),
                  ),
                  leading: Icon(Icons.group),
                  title: Text(groupList[index]['name']),
                );
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMemberGroup(),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}
