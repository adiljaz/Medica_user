
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CustomTextFormField({

    required this.fonrmtype,
    required this.formColor,
    required this.Textcolor,
    required this.controller,
    required this.value,
    this.icons,
    this.suficon,
    this.obscuretext = false,
    this.textstype,
  });

  final FormFieldValidator<String> value;
  final String fonrmtype;
  final Color formColor;
  final Icon? icons;
  final Widget? suficon;
  final Color Textcolor;
  final TextEditingController controller;
  final TextInputType? textstype; 

  bool obscuretext = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        keyboardType: textstype,
        obscureText: obscuretext,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: value,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icons,
          suffixIcon: suficon,
          labelText: fonrmtype,
          labelStyle: TextStyle(
            color: Textcolor,
            fontWeight: FontWeight.w400,
          ),
          fillColor: formColor,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Theme.of(context)
                  .primaryColor, // Use theme color for focused border
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 220, 219, 219),
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            // Define border style for validation error
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red, // Red border for validation error
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Define border style for focused validation error
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red, // Red border for focused validation error
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
