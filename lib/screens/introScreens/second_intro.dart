import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondIntro extends StatelessWidget {
  const SecondIntro({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/intro_background.jpg'),
          Positioned(
              top: mediaQuery.size.height * 0.07,
              child: Center(
                  child: Image.asset(
                'assets/images/dr22.png',
                fit: BoxFit.cover,
              ))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height * 0.35,
                decoration: const BoxDecoration(
                    color: Colormanager.whiteContainer,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                  children: [
                    const Spacer(),
                    Text('Thousands of',
                        style: GoogleFonts.firaSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colormanager.titleText),
                        )),
                    Text('Doctors & Experts to',
                        style: GoogleFonts.firaSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colormanager.titleText),
                        )),
                    Text('help your Health !',
                        style: GoogleFonts.firaSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colormanager.titleText),
                        )),
                    const Spacer(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
