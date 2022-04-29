import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:p_0_fire/constant.dart';
import 'package:p_0_fire/constant_functions.dart';
import 'package:p_0_fire/widgets/custom_alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  int itemsCount = 0;
  bool showProgress = false;

  File file = File('-1');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
        progressIndicator: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blueGrey,
          ),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              Colors.white,
            ),
          ),
        ),
        inAsyncCall: showProgress,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile info'),
            backgroundColor: Colors.green,
            actions: [
              VerticalDivider(
                  width: 10, color: Colors.white, endIndent: 10, indent: 10),
              SizedBox(
                width: 10,
              ),
              TextButton.icon(
                onPressed: onSubmitPressed,
                icon: Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.white,
                ),
                label: Text('Save',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  // SizedBox(width: 10,),
                                  Center(
                                      child: file.path == '-1'
                                          ? Material(
                                              color: Colors.blue,
                                              shape: CircleBorder(),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                onTap: () {
                                                  onSelectImagePressed();
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 50,
                                                  child: Icon(
                                                    Icons.add_a_photo,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage:
                                                      FileImage(file),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      onSelectImagePressed();
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      child: Icon(
                                                          Icons.add_a_photo,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Please provide your name \nand an optional profile photo',style: kTextStyleProfileScreen,)
                                ],
                              ),
                              TextFormField(
                                decoration: kMyInputDecoration.copyWith(
                                  label: Text(
                                    'Full Name',
                                    style: TextStyle(fontSize: 15,color: Colors.black),

                                  ),
                                  hintText: 'نام خود را وارد کنید',
                                ),
                                controller: nameController,
                                maxLength: 30,
                                validator: (value) => value!.isEmpty
                                    ? 'please enter full name'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //complate later
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }

  onSubmitPressed() async {
    String uid = auth.currentUser!.uid;
    String name = nameController.text;
    String phoneNumber=auth.currentUser!.phoneNumber.toString();
    setState(() {
      showProgress = true;
    });
    String imagePath = '-1';
    if (file.path != '-1') {
      imagePath = await uploadItemImage();
    }
    Map<String, dynamic> itemMap = Map();
    if(name.length<4){
        nameController.text = 'Please type more👈🏻👈🏻👈🏻';
        Timer(Duration(seconds: 2), () {
          nameController.text = '';
        });
        return;
    }
    itemMap['name'] = name;
    itemMap['userId'] = uid;
    itemMap['phone']=phoneNumber;
    if (imagePath != '-1') {
      itemMap['image'] = imagePath;
    } else {
      itemMap['image'] = null;
    }

    try {
      DocumentReference doc = await fireStore.collection('users').add(itemMap);
      print('success uploading');
      print('added document :id= ' + doc.id);
      showProgress = false;
      reseter();
      kNavigate(context, 'home');
    } catch (e) {
      setState(() {
        showProgress = false;
      });
      print('sth went wrong');
    }
  }

  Future<String> uploadItemImage() async {
    try {
      String filename = file.path.split('/').last;
      TaskSnapshot snapshot =
          await storage.ref().child('items/images/$filename').putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      print(url);
      return url;
    } catch (e) {
      print('error in image upload');
      print(e);
      return '-1';
    }
  }

  void onSelectImagePressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          selectImageFromGallery: selectImageFromGallery,
          selectImageFromCamera: selectImageFromCamera,
        );
      },
    );
  }

  void selectImageFromGallery() async {
    print('gallery');
    bool status = await selectImageFunction(ImageSource.gallery);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  void selectImageFromCamera() async {
    print('camera');
    bool status = await selectImageFunction(ImageSource.camera);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  Future<bool> selectImageFunction(ImageSource source) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final XFile pickedImage =
          await imagePicker.pickImage(source: source) ?? XFile('-1');
      print('---------------------------------------');
      print(pickedImage);
      print(pickedImage.path);
      print(pickedImage.name);
      if (pickedImage.path == '-1') {
        return false;
      }
      setState(() {
        file = File(pickedImage.path);
      });
      return true;
    } //
    catch (e) {
      print(e);
      return false;
    }
  }

  reseter() {
    setState(() {
      nameController.clear();
      file = File('-1');
    });
  }
}
