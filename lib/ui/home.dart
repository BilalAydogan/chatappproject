// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chatapp/groupchat/groupchatscreen.dart';
import 'package:chatapp/ui/people.dart';
import 'package:chatapp/ui/profile.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    Chat(),
    GroupChatHome(),
    PeopleRoom(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageList[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.messenger),
                label: "Chats",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: "Group Chats",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "People",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.grey,
                ),
                label: "Profile",
                backgroundColor: Colors.black),
          ],
        ));
  }
}
