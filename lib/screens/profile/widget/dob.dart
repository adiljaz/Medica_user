import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ignore: must_be_immutable
class DateofBirth extends StatelessWidget {
  final String? Function(String?) value;
  final TextEditingController controller;
  final String labeltext;
  void Function()? onTap;

  DateofBirth(
      {super.key,
      required this.value,
      required this.controller,
      required this.labeltext,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onTap: onTap,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: value,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_month),
            labelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500, color: Colormanager.grayText)),
            labelText: labeltext,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colormanager.blueContainer,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 220, 219, 219),
                width: 0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder()),
      ),
    );
  }
}
