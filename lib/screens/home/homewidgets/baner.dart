import 'package:fire_login/screens/home/seeall/seeall.dart';
import 'package:fire_login/screens/home/seeall/seeallwidget/alldoctors.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/banner.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.78),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: screenWidth * 0.6,
            top: screenHeight * 0.07,
            child: Image.asset(
              'assets/images/dr15 no bg.png',
              fit: BoxFit.cover,
              height: screenHeight * 0.185,
              width: screenWidth * 0.3,
            ),
          ),
          Positioned(
            left: screenWidth * 0.038,
            top: screenHeight * 0.01,
            child: Text(
              'Medical Checks!',
              style: GoogleFonts.dongle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colormanager.whiteText,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.038,
            top: screenHeight * 0.07,
            child: Text(
              "Check your health condition regularly",
              style: GoogleFonts.poppins(
                color: Colormanager.whiteText,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.038,
            top: screenHeight * 0.095,
            child: Text(
              'to minimize the incidence of disease in',
              style: GoogleFonts.poppins(
                color: Colormanager.whiteText,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.038,
            top: screenHeight * 0.12,
            child: Text(
              'the future.',
              style: GoogleFonts.poppins(
                color: Colormanager.whiteText,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.038,
            top: screenHeight * 0.15,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colormanager.whiteContainer,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(PageTransition(child: SeeAll(), type: PageTransitionType.fade ));  
              },
              child: Text(
                'Check now',
                style: GoogleFonts.dongle(
                  color: Colormanager.blueContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
   