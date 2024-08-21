
import 'package:flutter/material.dart';

class DetailsRound extends StatelessWidget {
  const DetailsRound({super.key, required this.icon});
  final Widget icon; 
  

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: 26,backgroundColor: Color.fromARGB(255, 192, 223, 255),child: icon,);
  }
}