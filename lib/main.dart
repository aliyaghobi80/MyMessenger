import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:p_0_fire/screens/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
          ),
          scaffoldBackgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),),

      home:LoginScreen(),
    );
  }
}
