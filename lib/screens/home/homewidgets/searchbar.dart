import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';

class Searchfield extends StatelessWidget {
  Searchfield({
    required this.controller,
    required this.value,
    this.icons,
  });

  final FormFieldValidator<String> value;

  final Icon? icons;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: value,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icons,
        labelStyle: TextStyle(
          color: Colormanager.grayText,
          fontWeight: FontWeight.w400,
        ),
        fillColor: Colormanager.whiteContainer,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
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
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
