import 'package:flutter/material.dart';
import 'package:p_0_fire/screens/chat_screen.dart';
import 'package:p_0_fire/screens/home_screen.dart';
import 'package:p_0_fire/screens/login.dart';
import 'package:p_0_fire/screens/profile_screen.dart';


kNavigate(BuildContext context, String path) {
  if (path == 'chat'||path=='profile') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if(path=='chat') {
            return ChatScreen(type: '', friendName: '', friendUid: '',image: '',);
          }
          else if(path=='profile'){
            return ProfileScreen();
          }
          else{
            return LoginScreen();
          }
        },
      ),
    );
  } //
  else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (path == 'home') {
            return HomeScreen();
          } else if (path == 'login') {
            return LoginScreen();
          } else {
            return HomeScreen();
          }
        },
      ),
    );
  }
}
