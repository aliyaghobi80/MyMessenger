import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/screens/group_screen.dart';
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
          children: [
            Column(
              children: [
                Center(
                  child: Container(
            margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                              placeholder: 'assets/images/loading2.gif',
                              image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXvZhpgZHkl_DQah0DsPPYm1d0B-ht7BESAw&usqp=CAU'
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupScreen(friendName: '', friendUid: '',image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXvZhpgZHkl_DQah0DsPPYm1d0B-ht7BESAw&usqp=CAU',),
                          ),
                        );
                      },
                      title: Text('All Users Chat'),
                      subtitle: Text(auth.currentUser!.email.toString()),
                    ),
                  ),
                )
              ],
            ),
            PvChatScreen(),
          ],
        ),
      ),
    );
  }
}
