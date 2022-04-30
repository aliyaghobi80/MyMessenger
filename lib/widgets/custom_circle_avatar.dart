

import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {

  String placeholder;
  String imageUrl;
  CustomCircleAvatar({required this.placeholder,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            height: 100,
            width: 100,
            placeholder: placeholder,
            image: imageUrl
        ),
      ),
    );
  }
}
