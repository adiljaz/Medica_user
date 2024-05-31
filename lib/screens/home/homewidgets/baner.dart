import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Container(
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Opacity(
                opacity: 0.78,
                child: Image.asset(
                  'assets/images/banner.jpg',
                  fit: BoxFit.cover,
                  width: mediaQuery.size.width * 0.9,
                  height: mediaQuery.size.height * 0.22,
                ),
              )),
          Positioned(
            left: mediaQuery.size.width * 0.6 ,
            top: mediaQuery.size.height * 0.07,
            child: Image.asset(
              'assets/images/dr15 no bg.png',
              fit: BoxFit.cover,
              height: mediaQuery.size.height * 0.185,
              width:mediaQuery.size.width*0.3, 
            ),
          ),
          Positioned(
             left: mediaQuery.size.width * 0.038,
              top: mediaQuery.size.height * 0.01, 
            child: Text(
              'Medical Checks!',
              style: GoogleFonts.dongle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40 ,
                  color: Colormanager.whiteText),
            ),
          ),
          Positioned(
              left: mediaQuery.size.width * 0.038,
              top: mediaQuery.size.height * 0.07,
              child: Text(
                "check your health condition regulerly ",
                style: GoogleFonts.poppins(
                  color: Colormanager.whiteText,
                    fontWeight: FontWeight.w500, fontSize: 12 ),
              )),
          Positioned(
              left: mediaQuery.size.width * 0.038,
              top: mediaQuery.size.height * 0.095,
              child: Text('to minimize the incidence of disease in',
              
                  style: GoogleFonts.poppins(
                    color: Colormanager.whiteText,

                      fontWeight: FontWeight.w500, fontSize: 11))),
          Positioned(
              left: mediaQuery.size.width * 0.038,
              top: mediaQuery.size.height * 0.12,
              child: Text(
                'the future.',
                style: GoogleFonts.poppins(
                  color: Colormanager.whiteText ,
                    fontWeight: FontWeight.w500, fontSize: 12 ),
              )),
          Positioned(
            left: mediaQuery.size.width * 0.038,
            top: mediaQuery.size.height * 0.15,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colormanager.whiteContainer)),
                onPressed: () {}, 
                child: Text(
                  ' Check now  ',
                  style: GoogleFonts.dongle(
                    color: Colormanager.blueContainer,
                      fontWeight: FontWeight.bold, fontSize: 24 ),
                )),
          )
        ],
      ),
    );
  }
}
