import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/constant_functions.dart';
import 'package:p_0_fire/screens/group_screen.dart';
import 'package:p_0_fire/widgets/custom_circle_avatar.dart';
import 'package:p_0_fire/widgets/user_list.dart';

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

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String imageUrl =
      'https://is1-ssl.mzstatic.com/image/thumb/Purple122/v4/52/39/4d/52394d54-0782-e9ca-ca72-7336a0870249/source/256x256bb.jpg';

  int likeCounter = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(80)),
                      color: Colors.green,
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: userRef
                          .where('userId', isEqualTo: currentUserId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error'),
                          );
                        } else if (!snapshot.hasData) {
                          Center(
                            child: Text('No Data'),
                          );
                        }
                        return Column(
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot doc) {
                            Map<String, dynamic> data =
                                doc.data()! as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                CustomCircleAvatar(
                                    placeholder: 'assets/images/loading.gif',
                                    imageUrl: data['image'],
                                    borderRadius: 50,
                                    radius: 60),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('name: ${data['name']}'),
                                Divider(height: 5, color: Colors.black),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('phone: ${data['phone']}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(height: 5, color: Colors.black),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    )),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue.shade50,
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      Container(

                        decoration: BoxDecoration(
                            color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: ListTile(
                          title: const Text('Change Profile'),
                          onTap: () {
                            kNavigate(context, 'profile');
                          },
                        ),
                      ),
                      Divider(height: 10,color: Colors.black,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: ListTile(
                          tileColor: Colors.red,
                          title: Row(
                            children: [
                              Text('Like:'),
                              Spacer(),
                              Text(likeCounter.toString()+' ❤️'),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              likeCounter++;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
                              image:
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXvZhpgZHkl_DQah0DsPPYm1d0B-ht7BESAw&usqp=CAU'),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupScreen(
                              friendName: '',
                              friendUid: '',
                              image:
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXvZhpgZHkl_DQah0DsPPYm1d0B-ht7BESAw&usqp=CAU',
                            ),
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
            UserList(),
          ],
        ),
      ),
    );
  }
}
