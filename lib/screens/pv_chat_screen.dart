import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/widgets/user_list.dart';

class PvChatScreen extends StatefulWidget {
  const PvChatScreen({Key? key}) : super(key: key);

  @override
  State<PvChatScreen> createState() => _PvChatScreenState();
}

class _PvChatScreenState extends State<PvChatScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance.collection('Messages').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _messagesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (snapshot.data == null) {
              return const Center(
                child: Text('No User Found!!!'),
              );
          }
          return  UserList();

        });
  }
}

