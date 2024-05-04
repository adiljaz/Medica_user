import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  const Signin({super.key, required this.mediaQuery, required this.buttontype});

  final MediaQueryData mediaQuery;

  final String buttontype;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: mediaQuery.size.height * 0.06,
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colormanager.blueContainer),
        child: Center(
            child: Text(
          buttontype,
          style: TextStyle(
              color: Colormanager.whiteText,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        )),
      ),
    );
  }
}
