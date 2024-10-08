import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Drtype extends StatelessWidget {
  final String typeText;
  final double width;
  final double height;
  final bool isSelected;

  Drtype({
    required this.typeText,
    required this.width,
    required this.height,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colormanager.blueContainer, width: 2),
        color: isSelected ? Colormanager.blueContainer : Colormanager.whiteContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          typeText,
          style: GoogleFonts.dongle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: isSelected ? Colormanager.whiteText : Colormanager.blueContainer,
          ),
        ),
      ),
    );
  }
} 