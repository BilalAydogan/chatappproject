// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_import
import 'package:chatapp/groupchat/groupchatscreen.dart';
import 'package:chatapp/method/methods.dart';
import 'package:chatapp/ui/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController? controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller!.repeat(reverse: true);
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
    _search.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: const Text("Chat"),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      /* floatingActionButton: FloatingActionButton(
          child: Icon(Icons.group),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => GroupChatHome()))), */
      body: isLoading
          ? Column(
              children: <Widget>[
                SizedBox(
                  height: size.height / 20,
                  width: size.width,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width / 1.01,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        suffixIcon: Icon(
                          Icons.search,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                Column(
                  children: [
                    Text(
                      "Not Found! Please try Again...",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    CircularProgressIndicator(
                      value: controller!.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: const Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.height / 20,
                    width: size.width,
                  ),
                  Container(
                    height: size.height / 14,
                    width: size.width / 1.01,
                    child: Container(
                      height: size.height / 14,
                      width: size.width / 1.15,
                      child: TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: Icon(
                            Icons.search,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  ElevatedButton(
                    onPressed: onSearch,
                    child: const Text("Search"),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  userMap != null
                      ? ListTile(
                          onTap: () {
                            String roomId = chatRoomId(
                                _auth.currentUser!.displayName!,
                                userMap!['name']);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  chatRoomId: roomId,
                                  userMap: userMap!,
                                ),
                              ),
                            );
                          },
                          leading: const Icon(Icons.account_box),
                          title: Text(
                            userMap!['name'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(userMap!['email']),
                          trailing: Icon(
                            Icons.chat,
                            color: Colors.black,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
    );
  }
}
