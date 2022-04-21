import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/constant_functions.dart';

class PvChatScreen extends StatefulWidget {
  const PvChatScreen({Key? key}) : super(key: key);

  @override
  State<PvChatScreen> createState() => _PvChatScreenState();
}

class _PvChatScreenState extends State<PvChatScreen> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('user');

  CollectionReference messageRef =
      FirebaseFirestore.instance.collection('Messages');

  @override
  Widget build(BuildContext context) {
    //Read Data in realTime Snapshot
    final Stream<QuerySnapshot> _profile = FirebaseFirestore.instance
        .collection('user')
        .snapshots(includeMetadataChanges: true);



    return StreamBuilder<QuerySnapshot>(

      //this stream just read time the message collection
      stream: messageRef
          .orderBy('time', descending: false).limitToLast(1).snapshots(),

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        return StreamBuilder(
          //this stream read profile
            stream:  _profile,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot2) {
            var date1 = snapshot1.data!.docs.map((DocumentSnapshot document) {

                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

                return data['time']??'';
              });

              if (snapshot2.hasError) {
                return Text('Something went wrong');
              }
              if (!snapshot1.hasData) return const Text('Loading...');
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: snapshot2.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
                  print(document.id); // <= Should print the doc id
                  return lisTile(data, auth,date1);
                }).toList(),
              );
            });
      },
    );
  }

  Widget lisTile(Map data2, FirebaseAuth auth ,Iterable tim) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: (){
          kNavigate(context, 'chat');
        },
        title: Text(data2['name']),
        subtitle: Text(auth.currentUser!.phoneNumber.toString()),
        leading: CircleAvatar(
          radius: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: data2['image'] ?? 'assets/images/loading.gif',
                fit: BoxFit.cover),
          ),
        ),
        contentPadding: EdgeInsets.all(5),
        tileColor: Colors.red,
        style: ListTileStyle.list,
        trailing: Text("آخرین بازدید:"+
            tim.toString()),
      ),
    );
  }
}
