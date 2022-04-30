import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/constant.dart';
import 'package:p_0_fire/constant_functions.dart';
import 'package:p_0_fire/widgets/chat_message_dialog.dart';

class GroupScreen extends StatefulWidget {
  String friendUid;
  String friendName;
  String image;

  GroupScreen({
    required this.friendName,
    required this.friendUid,
    required this.image,
  });

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference groupRef =
      FirebaseFirestore.instance.collection('groupChats');
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isEditing = false;
  String updatingMessage = '';
  String updatingMessageID = '';

  @override
  void initState() {
    super.initState();
  }

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
        actions: [
          TextButton(
              onPressed: () {
               kNavigate(context, 'home');
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: groupRef
                    .orderBy('date', descending: true)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      reverse: true,
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map(
                        (doc) {
                          String id = doc.id;
                          Map data = doc.data() as Map;
                          bool isMe = data['sender'] == auth.currentUser!.uid;
                          return GestureDetector(
                            onTap: () {
                              onMessageTapped(data, id);
                            },
                            child:  Column(
                              children: [
                                Bubble(
                                  margin: BubbleEdges.only(
                                      top: 5,
                                      left: isMe ? 50 : 0,
                                      right: !isMe ? 50 : 0),
                                  padding: BubbleEdges.all(5),
                                  nip: (isMe)
                                      ? BubbleNip.rightBottom
                                      : BubbleNip.leftBottom,
                                  // nipHeight: 10,
                                  nipWidth: 5,
                                  color: (isMe) ? kGreenColor : kLightDarkColor,
                                  alignment: (isMe)
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  elevation: 3,
                                  shadowColor: Colors.green,
                                  borderUp: true,
                                  borderColor: Colors.blue,
                                  borderWidth: 0.4,
                                  radius: Radius.circular(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        (isMe) ? 'me' : data['sender_phone'] ?? 'you',
                                        style: kMyTextStyle.copyWith(
                                            fontSize: 12,
                                            color: Colors.yellow,
                                            debugLabel: 'hi'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(data['text'],
                                            style: (isMe)
                                                ? kMyTextStyle
                                                : kOtherTextStyle),
                                      ),
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now()
                                            .toString()
                                            .substring(11, 16)
                                            : data['createdOn']
                                            .toDate()
                                            .toString()
                                            .substring(11, 16),
                                        style: (isMe)
                                            ? kTimeTextStyle.copyWith(
                                            color: Colors.grey.shade800)
                                            : kTimeTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    );
                  } //
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Visibility(
                    visible: isEditing,
                    child: Container(
                      width: size.width - 65,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(225, 255, 199, 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4),
                        ),
                      ),
                      child: Text(updatingMessage),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        onTap: () {
                          Timer(
                            const Duration(milliseconds: 300),
                            () {
                              scrollController.jumpTo(
                                  scrollController.position.minScrollExtent);
                            },
                          );
                        },
                        controller: controller,
                        decoration: kMyInputDecoration.copyWith(
                          hintText: 'Type your message...',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    String text = controller.text;
    print(text);
    if (text.length <= 2) {
      print('type sth more');
      return;
    }

    Map<String, dynamic> newMap = Map();
    newMap['text'] = text;
    String dateTime = DateTime.now().toString();
    String date = dateTime.substring(0, 10);
    String time = dateTime.substring(11, 19);
    newMap['time'] = time;
    newMap['date'] = date;
    // edit
    if (isEditing == true) {
      DocumentReference doc = groupRef.doc(updatingMessageID);
      doc.update({
        'text': text,
      });
    } // add
    else {
      newMap['sender'] = auth.currentUser!.uid;
      newMap['sender_phone'] = auth.currentUser!.phoneNumber;
      groupRef.add(newMap).then((value) {
        print(value);
      });
    }
    resetValues();
  }

  onMessageTapped(Map data, String id) {
    showDialog(
      builder: (BuildContext context) {
        return ChatDialog(
          onDelete: () {
            onDelete(data, id);
          },
          onEdite: () {
            onEdit(data, id);
          },
        );
      },
      context: context,
    );
  }

  onDelete(Map data, String id) async {
    groupRef.doc(id).delete();
    Navigator.pop(context);
  }

  onEdit(Map data, String id) async {
    setState(() {
      isEditing = true;
      updatingMessage = data['text'];
      controller.text = data['text'];
      updatingMessageID = id;
    });
    Navigator.pop(context);
  }

  resetValues() {
    controller.clear();
    setState(() {
      updatingMessageID = '';
      updatingMessage = '';
      isEditing = false;
    });
  }
}
