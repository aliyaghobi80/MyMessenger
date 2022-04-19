import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:p_0_fire/constant.dart';
import 'package:p_0_fire/widgets/chat_message_dialog.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference messageRef =
  FirebaseFirestore.instance.collection('Messages');
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isEditing = false;
  String updatingMessage = '';
  String updatingMessageId = '';

  @override
  void initState() {
    super.initState();
  }

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // bool isDarkMode = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: messageRef
                      .orderBy('date', descending: true)
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        reverse: true,
                        controller: scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((doc) {
                          Map data = doc.data() as Map;
                          String id = doc.id;
                          bool isMe = data['sender'] == auth.currentUser!.uid;
                          return GestureDetector(
                            onTap: () {
                              onMessageTaped(data, id);
                            },
                            child: Column(
                              children: [
                                Bubble(
                                  alignment: Alignment.center,
                                  color: Color.fromRGBO(179, 255, 178, 1.0),
                                  child: Text('TODAY',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 11.0)),
                                ),
                                Bubble(
                                  margin: BubbleEdges.only(
                                      top: 10,
                                      left: isMe ? 50 : 0,
                                      right: !isMe ? 50 : 0),
                                  padding: BubbleEdges.all(10),
                                  nip: (isMe)
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                                  color: (isMe) ? kGreenColor : kLightDarkColor,
                                  alignment: (isMe)
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  elevation: 3,
                                  shadowColor: Colors.green,
                                  borderUp: true,
                                  borderColor: Colors.blue,
                                  borderWidth: 0.4,
                                  radius: Radius.circular(15),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(data['text'],
                                          style: (isMe)
                                              ? kMyTextStyle
                                              : kOtherTextStyle),
                                      Text(
                                        data['time'].toString().substring(0, 5),
                                        style: kTimeTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0, left: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Visibility(
                    visible: isEditing,
                    child: Container(
                      padding: EdgeInsets.only(left: 5, bottom: 10),
                      width: size.width - 65,
                      decoration: BoxDecoration(
                        color: kGrayColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4),
                        ),
                      ),
                      child: Expanded(
                        child: Text(
                          updatingMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(),
              ],
            ),
          ),
          SizedBox(
            height: 10,
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
                    Timer(Duration(milliseconds: 300), () {
                      scrollController
                          .jumpTo(scrollController.position.minScrollExtent);
                    });
                  },
                  controller: controller,
                  decoration: kMyInputDecoration.copyWith(
                    label: Text('Type...',style: TextStyle(fontSize: 15),),
                    hintText: 'پیغامی را بنویسید',
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
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    String text = controller.text;
    print(text);
    if (text.length <= 2) {
      controller.text = 'Please type more👈🏻👈🏻👈🏻';
      Timer(Duration(seconds: 2), () {
        controller.text = '';
      });
      return;
    }

    Map<String, dynamic> newMap = Map();
    newMap['text'] = text;
    String dateTime = DateTime.now().toString();
    String date = dateTime.substring(0, 10);
    String time = dateTime.substring(11, 19);
    newMap['time'] = time;
    newMap['date'] = date;
    //edit
    if (isEditing == true) {
      DocumentReference doc = messageRef.doc(updatingMessageId);
      doc.update({
        "text": text,
      });
    } //add
    else {
      newMap['sender'] = auth.currentUser!.uid;
      newMap['sender_phone'] = auth.currentUser!.phoneNumber;
      messageRef.add(newMap).then((value) {
        print(value);
      });
    }
    resetValues();
  }

  onMessageTaped(Map data, String id) {
    showDialog(
      context: context,
      barrierLabel: 'Hello',
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
    );
  }

  onDelete(Map data, String id) async {
    messageRef.doc(id).delete();
    Navigator.pop(context);
    print(id);
  }

  onEdit(Map data, String id) async {
    setState(() {
      isEditing = true;
      updatingMessage = data['text'];
      controller.text = data['text'];
      updatingMessageId = id;
    });
    Navigator.pop(context);
  }

  resetValues() {
    controller.clear();
    setState(() {
      updatingMessageId = '';
      updatingMessage = '';
      isEditing = false;
    });
  }
}
