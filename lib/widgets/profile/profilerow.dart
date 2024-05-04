import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileOptions extends StatelessWidget {
  final IconData leadingIcon;
  // ignore: prefer_typing_uninitialized_variables
  final String typetext;
  final IconData ? trialingIcon;
  // ignore: use_key_in_widget_constructors
  const ProfileOptions(
      {required this.leadingIcon, required this.typetext, this.trialingIcon});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    return Row(
      children: [
        SizedBox(
          width: mediaquery.size.width * 0.04,
        ),
        Icon(
          leadingIcon,
          color: Colormanager.iconscolor,
          size: 35,
        ),
        SizedBox(
          width: mediaquery.size.width * 0.05,
        ),
        Text(
          typetext,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            color: Colormanager.blackText,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          )),
        ),
        Spacer(),
        Icon(
          trialingIcon, 
          size: 30,
          color: Colormanager.othericons,
        ),
        SizedBox(
          width: mediaquery.size.width * 0.08,
        ),
      ],
    );
  }
}
