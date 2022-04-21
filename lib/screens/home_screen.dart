import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/screens/chat_screen.dart';
import 'package:p_0_fire/screens/pv_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('profile');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.group),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Group'),
                ],
              )),
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Persons'),
                ],
              )),
            ],
          ),
          title: Text('MyMessenger'),
        ),
        body: TabBarView(
          children: const [
            ChatScreen(),
            PvChatScreen(),
          ],
        ),
      ),
    );
  }
  }

