import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CutomTextFormField extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CutomTextFormField(
      {required this.fonrmtype,
      required this.formColor,
      required this.Textcolor,
      required this.controller,
      this.icons,
      this.suficon});
  final String fonrmtype;

  final Color formColor;
  final Icon? icons;

  final Icon? suficon;

  final Color Textcolor;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icons,
          suffixIcon: suficon,
          labelText: fonrmtype,
          labelStyle: TextStyle(color: Textcolor, fontWeight: FontWeight.w400),
          fillColor: formColor,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 220, 219, 219),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
