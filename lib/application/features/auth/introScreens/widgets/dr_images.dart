

import 'package:flutter/material.dart';

class DrImages extends StatelessWidget {
  final ImageProvider<Object> image;
  final double radius;
  DrImages({required this.image,required this.radius}); 

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      
      backgroundImage:image ,
      radius: radius,
    );
  }
}
