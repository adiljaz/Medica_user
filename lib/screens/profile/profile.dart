import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/profile/profilerow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colormanager.scaffold,
        body: Column(
          children: [
            SizedBox(
              height: mediaquery.size.height * 0.02,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  height: 50,
                  width: 90,
                ),
                SizedBox(
                  width: mediaquery.size.width * 0.15,
                ),
                Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            Stack(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colormanager.iconscolor,
                  size: 200,
                ),
                Positioned(
                    top: 120,
                    left: 145,
                    child: Icon(
                      Icons.add_to_photos,
                      size: 40,
                    ))
              ],
            ),
            Text(
              'adil jaseeem',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
            ),
            Text(
              '9497062038',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
              SizedBox(
              height: mediaquery.size.height * 0.02,
            ), 
            
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Divider(),
            ),
            SizedBox(
              height: mediaquery.size.height * 0.03,
            ),
            ProfileOptions(
              leadingIcon: Icons.account_circle,
              typetext: 'EditProfile',
              trialingIcon: Icons.navigate_next,
            ),
            SizedBox(
              height: mediaquery.size.height * 0.015,
            ),
            ProfileOptions(
                leadingIcon: Icons.remove_red_eye,
                typetext: 'Dark Mode',
                trialingIcon: Icons.navigate_next),
            SizedBox(
              height: mediaquery.size.height * 0.015,
            ),
            ProfileOptions(
                leadingIcon: Icons.person_2,
                typetext: 'Ivite friends',
                trialingIcon: Icons.navigate_next),
            SizedBox(
              height: mediaquery.size.height * 0.015,
            ),
            ProfileOptions(
                leadingIcon: Icons.email,
                typetext: 'Feed Back',
                trialingIcon: Icons.navigate_next),
            SizedBox(
              height: mediaquery.size.height * 0.015,
            ),
            ProfileOptions(
                leadingIcon: Icons.privacy_tip,
                typetext: 'Privacy Policy',
                trialingIcon: Icons.navigate_next),
            SizedBox(
              height: mediaquery.size.height * 0.015,
            ),
            ProfileOptions(
                leadingIcon: Icons.logout,
                typetext: 'Logout ',
                trialingIcon: Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
