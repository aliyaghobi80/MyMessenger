import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:p_0_fire/constant.dart';
import 'package:p_0_fire/constant_functions.dart';
import 'package:p_0_fire/widgets/chat_message_dialog.dart';
import 'package:p_0_fire/widgets/custom_circle_avatar.dart';

class ChatScreen extends StatefulWidget {
  String type;
  String friendUid;
  String friendName;
  String image;

  ChatScreen({
    required this.type,
    required this.friendName,
    required this.friendUid,
    required this.image,

  });

  @override
  _ChatScreenState createState() => _ChatScreenState(friendName, friendUid);
}

class _ChatScreenState extends State<ChatScreen> {
  DateTime dateNow = DateTime.now();

  String date = DateTime.now().toString().substring(0, 10);
  CollectionReference chatsRef = FirebaseFirestore.instance.collection('chats');
  CollectionReference groupRef = FirebaseFirestore.instance.collection('groupChats');
  final friendUid;
  final friendName;
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;

  _ChatScreenState(this.friendName, this.friendUid);

  @override
  void initState() {
    super.initState();
    chatsRef
        .where('users', isEqualTo: {friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocId = querySnapshot.docs.single.id;
          } else {
            chatsRef.add({
              'users': {currentUserId: null, friendUid: null}
            }).then((value) => {chatDocId = value});
          }
        })
        .catchError((error) {
          print(error);
        });
    setState(() {});
  }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isDarkMode = true;
  bool isEditing = false;
  String updatingMessage = '';
  String updatingMessageId = '';

  late Size size;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    // bool isDarkMode = false;
    return Scaffold(
      backgroundColor: (isDarkMode) ? Colors.grey.shade800 : Colors.white,
      appBar: AppBar(
        title:
            Text(widget.type == 'usersList' ? widget.friendName : 'Group'),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                if (isDarkMode) {
                  isDarkMode = false;
                } else {
                  isDarkMode = true;
                }
              });
            },
            label: Text(
              (isDarkMode) ? 'dark' : 'Light',
              style: TextStyle(color: Colors.black),
            ),
            icon: Icon(
              (isDarkMode) ? Icons.dark_mode : Icons.light_mode,
              color: Colors.black,
            ),
          ),
          TextButton(
              onPressed: () {
                if(widget.type == 'group'){
                  kNavigate(context, 'home');
                }
                else{
                Navigator.pop(context);
                }
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              )),
        ],
        leading:CustomCircleAvatar(placeholder: 'assets/images/loading2.gif', imageUrl: widget.image,borderRadius: 50,radius: 25,),
      ),
      body: Column(
        children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: chatsRef
                        .doc(chatDocId)
                        .collection('messages')
                        .orderBy('createdOn', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('error'),
                        );
                      }
                      if (snapshot.hasData) {
                        //this timer for reload chatScreen
                        Timer(
                          Duration(microseconds: 1),
                              () {
                            setState(() {});
                          },
                        );
                        return ListView(
                          reverse: true,
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: snapshot.data!.docs.map((doc) {
                            Map data = doc.data() as Map;
                            String id = doc.id;
                            bool isMe = data['uid'] == auth.currentUser!.uid;
                            return GestureDetector(
                              onTap: () {
                                onMessageTaped(data, id, isMe);
                              },
                              child: Column(
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
                                          (isMe) ? 'me' : friendName,
                                          style: kMyTextStyle.copyWith(
                                              fontSize: 12,
                                              color: Colors.yellow,
                                              debugLabel: 'hi'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Text(data['msg'],
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
                          style: kOtherTextStyle,
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
                    label: Text(
                      'Type...',
                      style: TextStyle(fontSize: 15),
                    ),
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
                onPressed: () {
                  setState(() {
                    sendMessage(controller.text);
                  });
                },
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


  void sendMessage(String msg) {
    if (msg.length <= 2) {
      controller.text = 'Please type more👈🏻👈🏻👈🏻';
      Timer(Duration(seconds: 2), () {
        controller.text = '';
      });
      return;
    }
    //edit
    if (isEditing == true) {
      DocumentReference doc =
          chatsRef.doc(chatDocId).collection('messages').doc(updatingMessageId);
      doc.update({
        "msg": msg,
      });
    }

    //add data
    chatsRef.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'msg': msg
    }).then((value) {
      controller.text = '';
    });
    resetValues();
  }

  onMessageTaped(Map data, String id, bool isMe) {
    showDialog(
      context: context,
      barrierLabel: 'Hello',
      builder: (BuildContext context) {
        return ChatDialog(
          onDelete: () {
            onDelete(data, id);
          },
          onEdite: () {
            if (isMe) {
              onEdit(data, id);
            } else {
              return;
            }
          },
        );
      },
    );
  }

  onDelete(Map data, String id) async {
    chatsRef.doc(chatDocId).collection('messages').doc(id).delete();
    Navigator.pop(context);
    print(id);
  }

  onEdit(Map data, String id) async {
    setState(() {
      isEditing = true;
      updatingMessage = data['msg'];
      controller.text = data['msg'];
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
