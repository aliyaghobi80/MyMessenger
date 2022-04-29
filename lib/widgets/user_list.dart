import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/screens/chat_screen.dart';

class UserList extends StatefulWidget {
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final user = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: user
            .collection('users')
            .where('userId', isNotEqualTo: currentUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  if (document.id == auth.currentUser!.uid) {
                    return Container(
                      height: 0,
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.green),
                    margin: EdgeInsets.symmetric(vertical: index == 0 ? 0 : 1),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              friendName: document['name']?? 'no name',
                              type: 'usersList',
                              friendUid: document['userId'],
                              image:document['image'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqcy7V5IRCC0XDmioZZRTOj3Gdb42X2ueVg&usqp=CAU',
                            ),
                          ),
                        );
                      },
                      minVerticalPadding: 1,
                      contentPadding: EdgeInsets.all(5),
                      horizontalTitleGap: 10,
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/loading2.gif',
                            image: document['image'] ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqcy7V5IRCC0XDmioZZRTOj3Gdb42X2ueVg&usqp=CAU',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      title: Text(document['name'] ?? 'This user does not have a username'),
                      subtitle: Text('hello'),
                      trailing: Text(document['phone']),
                      // subtitle: ,
                    ),
                  );
                }),
          );
        });
  }
}
