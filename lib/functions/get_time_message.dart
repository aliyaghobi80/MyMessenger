import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/constant.dart';

class GetMessageTime extends StatelessWidget {
   String documentId='LNUnZOySHlFiGkesUAYR';
  //GetMessageTime(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference messageRef = FirebaseFirestore.instance.collection('Messages');

    return FutureBuilder<DocumentSnapshot>(
      future: messageRef.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text(data['time'] ?? 'time',style:kNamePersonTextStyle.copyWith(fontSize: 15) ,);
        }


        return Text("loading");
      },
    );
  }
}