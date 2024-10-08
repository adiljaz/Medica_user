import 'package:fire_login/screens/home/department/special.dart';
import 'package:fire_login/screens/home/favourite/favourite.dart';
import 'package:fire_login/screens/home/homewidgets/baner.dart';
import 'package:fire_login/screens/home/seeall/seeall.dart';
import 'package:fire_login/screens/home/seeall/seeallwidget/allhorizontal.dart';
import 'package:fire_login/screens/home/widgets/doctortype.dart';
import 'package:fire_login/screens/home/widgets/headerprofile/headerprfile.dart';
import 'package:fire_login/screens/message/gemini.dart';
import 'package:fire_login/screens/search/saech.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colormanager.scaffold,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: HomePageHeader()),
                    SizedBox(width: mediaQuery.size.width * 0.013),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(PageTransition(
                              child: Favourite(),
                              type: PageTransitionType.fade));
                        },
                        icon: Icon(
                          IconlyBold.heart,
                          color: Colormanager.blueicon,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              child: SearchPage(),
                              type: PageTransitionType.fade));
                        },
                        child: Container(
                          width: mediaQuery.size.width * 0.89,
                          height: mediaQuery.size.height * 0.065,
                          decoration: BoxDecoration(
                            color: Colormanager.whiteContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(IconlyLight.search,
                                    color: Colormanager.grayText),
                                SizedBox(width: mediaQuery.size.width * 0.03),
                                Text(
                                  'Search',
                                  style: GoogleFonts.dongle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 28,
                                    color: Colormanager.grayText,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(PageTransition(
                                        child: GeminiAi(),
                                        type: PageTransitionType.fade));
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    child: Transform.scale(
                                      scale: 1.3,
                                      child:
                                          Lottie.asset('assets/lottie/ai.json'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.width * 0.06),
                      const BannerImage(),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Doctor Speciality',
                                style: GoogleFonts.dongle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: const SeeAll(),
                                    type: PageTransitionType.fade));
                              },
                              child: Text(
                                'See All',
                                style: GoogleFonts.dongle(
                                    fontWeight: FontWeight.bold,
                                    color: Colormanager.blueContainer,
                                    fontSize: 20), // Adjusted font size
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildDoctorSpecialities(context, mediaQuery),
                      Text(
                        'Top Doctors',
                        style: GoogleFonts.dongle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * 0.32,
                        child: AllDoctorsHorizontal(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorSpecialities(
      BuildContext context, MediaQueryData mediaQuery) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAnimatedDoctorTypeItem(
                  context,
                  HomeDepartment(department: 'General'),
                  IconlyBold.home,
                  'General'),
              _buildAnimatedDoctorTypeItem(
                  context,
                  HomeDepartment(department: 'Dentist'),
                  FontAwesomeIcons.tooth,
                  'Dentist'),
              _buildAnimatedDoctorTypeItem(context,
                  HomeDepartment(department: 'Nephrology'), null, 'Nephrolo..',
                  imagePath: 'assets/images/nephrology.png'),
              _buildAnimatedDoctorTypeItem(
                  context,
                  HomeDepartment(department: 'Neurology'),
                  FontAwesomeIcons.brain,
                  'Neurol..'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAnimatedDoctorTypeItem(context,
                  HomeDepartment(department: 'Nutrition'), null, 'Nutrition',
                  imagePath: 'assets/images/Nutrition.png'),
              _buildAnimatedDoctorTypeItem(
                  context,
                  HomeDepartment(department: 'Pediatrics'),
                  FontAwesomeIcons.baby,
                  'Pediatri..'),
              _buildAnimatedDoctorTypeItem(
                  context,
                  HomeDepartment(department: 'Cardiologists'),
                  Icons.remove_red_eye,
                  'Cardiol..'),
              _buildAnimatedDoctorTypeItem(
                  context, SeeAll(), Icons.more_horiz, 'More'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedDoctorTypeItem(
      BuildContext context, Widget page, IconData? iconData, String text,
      {String? imagePath}) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(PageTransition(child: page, type: PageTransitionType.fade));
        },
        child: DoctorType(
          icon: iconData != null
              ? Icon(iconData, size: 28, color: Colormanager.blueicon)
              : null,
          image: imagePath != null
              ? Opacity(
                  opacity: 0.65,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    height: 36,
                    width: 36,
                  ),
                )
              : null,
          text: text,
        ),
      ),
    );
  }
}
