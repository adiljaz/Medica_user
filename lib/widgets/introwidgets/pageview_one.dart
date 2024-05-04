// ignore: file_names
import 'package:fire_login/widgets/introwidgets/dr_images.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class WelcomePageView extends StatelessWidget {

    PageController controller = PageController();
    WelcomePageView({super.key, required this.controller});

  

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery=MediaQuery.of(context); 
    return  Column(
      children: [
        Stack(
          children: [
            Container(
              width: mediaQuery.size.width,
              height: mediaQuery.size.height * 0.6,
            ),
            Positioned(
              left: mediaQuery.size.width * 0.22,
              top: mediaQuery.size.height * 0.06,
              child: DrImages(
                image: AssetImage('assets/images/dr 9.jpg'),
                radius: 45,
              ),
            ),
            Positioned(
                left: mediaQuery.size.width * 0.65,
                top: mediaQuery.size.height * 0.08,
                child: DrImages(
                    image: AssetImage('assets/images/dr12.jpg'), radius: 50)),
            Positioned(
                left: mediaQuery.size.width * 0.25,
                top: mediaQuery.size.height * 0.19,
                child: DrImages(
                    image: AssetImage(
                      'assets/images/Dr L 8.jpg',
                    ),
                    radius: 70)),
            Positioned(
                left: mediaQuery.size.width * 0.02,
                top: mediaQuery.size.height * 0.19,
                child: DrImages(
                    image: AssetImage('assets/images/Dr l 6.jpg'), radius: 30)),
            Positioned(
                left: mediaQuery.size.width * 0.7,
                top: mediaQuery.size.height * 0.25,
                child: DrImages(
                    image: AssetImage('assets/images/dr 11.jpg'), radius: 30)),
            Positioned(
                left: mediaQuery.size.width * 0.85,
                top: mediaQuery.size.height * 0.33,
                child: DrImages(
                    image: AssetImage('assets/images/dr 5.jpg'), radius: 20)),
            Positioned(
                left: mediaQuery.size.width * 0.6,
                top: mediaQuery.size.height * 0.38,
                child: DrImages(
                    image: AssetImage('assets/images/ladyDr.jpg'),
                    radius: 45)),
            Positioned(
                left: mediaQuery.size.width * 0.35,
                top: mediaQuery.size.height * 0.44,
                child: DrImages(
                    image: AssetImage(
                      'assets/images/dr16.jpg',
                    ),
                    radius: 30)),
            Positioned(
                left: mediaQuery.size.width * 0.03,
                top: mediaQuery.size.height * 0.34,
                child: DrImages(
                    image: AssetImage('assets/images/Dr l 7.jpg'), radius: 50)),
          ],
        ),
        Container(
          child: Text(
            'Welcome to ',
            style: GoogleFonts.basic(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colormanager.titleText)),
          ),
        ),
        Text(
          'Medica 👋🏻',
          style: GoogleFonts.basic(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colormanager.titleText)),
        ),
        SizedBox(height: mediaQuery.size.height*0.028,),
      
       

        Text(
          'The best online Doctor appoinment &',
          style: TextStyle(
              color: Colormanager.blackText, fontWeight: FontWeight.w500),
        ),
        Text('Consultation app of the cuntury for your',
            style: TextStyle(
                color: Colormanager.blackText, fontWeight: FontWeight.w500)),
        Text('health and medical needs!',
            style: TextStyle(
                color: Colormanager.blackText, fontWeight: FontWeight.w500)),
  
       
       
      ],
    );
  }
}