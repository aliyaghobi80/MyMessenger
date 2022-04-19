import 'package:flutter/material.dart';
import 'package:p_0_fire/constant_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.blue,
        child: ElevatedButton(
          onPressed: () {
            kNavigate(context, 'chat');
          },
          child: Text('chatScreen'),
        ),
      ),
    );
  }
}
