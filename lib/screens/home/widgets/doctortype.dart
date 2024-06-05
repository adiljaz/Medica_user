import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
class DoctorType extends StatelessWidget {
  const DoctorType({super.key, required this.text,required this.icon});

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colormanager.lightblue,
          radius: 29 ,
          child: icon,),
        Text(text),
      ],
    );
  }
}