import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
int counter=0;
final kMyInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  prefixIcon: Icon(CupertinoIcons.person),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
);


const kTextStyleProfileScreen=TextStyle(fontSize: 15,fontWeight: FontWeight.w400,);




const String kMyPhoneNumber = '+1 1111111111';
const kDarkColor = Color(0xFF0e1621);
const kLightDarkColor = Color(0xFF182533);
const kGrayColor = Color(0xFF3a4d61);
const kLightGrayColor = Color(0xFF6d7f8f);
const kGreenColor = Color(0xFF005c4b);
const kMyTextStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'Handlee');
const kOtherTextStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'b-nazanin');
const kTimeTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: kLightGrayColor,
);
const kTextStyleButton =
TextStyle(fontSize: 25, fontWeight: FontWeight.w500, fontFamily: 'Handlee');
const kStyleSomebody = BubbleStyle(
  nip: BubbleNip.leftTop,
  color: Colors.white,
  borderColor: Colors.blue,
  borderWidth: 1,
  elevation: 4,
  shadowColor: Colors.red,
  radius: Radius.elliptical(10, 10),
  borderUp: false,
  margin: BubbleEdges.only(top: 8, right: 50),
  alignment: Alignment.topLeft,
);

const kStyleMe = BubbleStyle(
  nip: BubbleNip.rightTop,
  color: Color.fromARGB(255, 225, 255, 199),
  borderColor: Colors.blue,
  borderWidth: 1,
  elevation: 3,
  shadowColor: Colors.tealAccent,
  radius: Radius.elliptical(10, 10),
  borderUp: false,
  margin: BubbleEdges.only(top: 8, left: 50),
  alignment: Alignment.topRight,
);

String validateMobile(String value) {


  if (value.isEmpty) {
    return 'Please enter Code!!!';
  } else if (value.length<6) {
    return 'Please enter Correct Code';
  }
  return 'ok✅';
}

