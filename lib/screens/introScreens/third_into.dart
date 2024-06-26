import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThirdIntro extends StatelessWidget {
  const ThirdIntro({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/intro_background.jpg'),
          Positioned(
              top: mediaQuery.size.height * 0.07,
              child:  Image.asset(
                'assets/images/dr15 no bg.png',
                fit: BoxFit.cover,
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: mediaQuery.size.width,
                decoration: const BoxDecoration(
                    color: Colormanager.whiteContainer,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(" Let's start living",
                        style: GoogleFonts.firaSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colormanager.titleText),
                        )),
                    Text('healthy and well',
                        style: GoogleFonts.firaSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colormanager.titleText),
                        )),
                    Text('With us right now!',
                        style: GoogleFonts.firaSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colormanager.titleText),
                        )),
                    const Spacer(),
                  ],
                ),
                height: mediaQuery.size.height * 0.35,
              ))
        ],
      ),
    );
  }
}
