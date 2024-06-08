import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DoctorType extends StatelessWidget {
  const DoctorType({super.key, required this.text, this.icon,this.image});

  final String text;
  final Icon ?icon;
  final Widget ?image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colormanager.lightblue,
          radius: 29 ,
          child: icon??image,),
          
        Text(text,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 13 ),),
      ],
    );
  }
}