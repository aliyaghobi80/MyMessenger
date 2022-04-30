

import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {

  String placeholder;
  String imageUrl;
  double borderRadius;
  double radius;
  CustomCircleAvatar({required this.placeholder,required this.imageUrl,required this.borderRadius,required this.radius});

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
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
