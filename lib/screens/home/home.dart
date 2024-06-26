import 'package:fire_login/screens/home/department/Neurologists/neurologi.dart';
import 'package:fire_login/screens/home/department/cardiologists/Cardio.dart';
import 'package:fire_login/screens/home/department/dentist/dentist.dart';
import 'package:fire_login/screens/home/department/general/general.dart';
import 'package:fire_login/screens/home/department/nephrology/nephrology.dart';
import 'package:fire_login/screens/home/department/nutrition/nutrition.dart';
import 'package:fire_login/screens/home/department/pediatrics/pediatrics.dart';
import 'package:fire_login/screens/home/favourite/favourite.dart';
import 'package:fire_login/screens/home/homewidgets/baner.dart';
import 'package:fire_login/screens/home/homewidgets/searchbar.dart';
import 'package:fire_login/screens/home/seeall/seeall.dart';
import 'package:fire_login/screens/home/seeall/seeallwidget/alldoctors.dart';
import 'package:fire_login/screens/home/seeall/seeallwidget/allhorizontal.dart';
import 'package:fire_login/screens/home/widgets/doctortype.dart';
import 'package:fire_login/screens/search/saech.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquerry = MediaQuery.of(context);

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
                    CircleAvatar(
                      radius: 27,
                      child: Image.network(''),
                    ),
                    SizedBox(
                      width: mediaquerry.size.width * 0.013,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Have a nice day 👋🏻 ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colormanager.grayText,
                                fontSize: 12),
                          ),
                          Text(
                            'Adil jaseem',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (){
                        Navigator.of(context).push(PageTransition(child:Favourite() , type: PageTransitionType.fade));
                      }, icon: Icon(
                        IconlyBold.heart,
                        color: Colormanager.blueicon,
                        size: 30,
                      ),)
                    ),
                   
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // search field
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageTransition(
                                child: SearchPage(),
                                type: PageTransitionType.fade));
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            IconlyLight.search,
                                            color: Colormanager.grayText,
                                          ),
                                          SizedBox(
                                            width:
                                                mediaquerry.size.width * 0.03,
                                          ),
                                          Text(
                                            'Search',
                                            style: GoogleFonts.dongle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 28,
                                                color: Colormanager.grayText),
                                          )
                                        ],
                                      ),
                                    )),
                                width: mediaquerry.size.width * 0.89,
                                height: mediaquerry.size.height * 0.065,
                                decoration: BoxDecoration(
                                    color: Colormanager.whiteContainer,
                                    borderRadius: BorderRadius.circular(8)),
                              )
                            ],
                          )),

                      SizedBox(
                        height: mediaquerry.size.width * 0.06,
                      ),
                      // banner
                      const BannerImage(),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Doctor Speciality',
                              style: GoogleFonts.dongle(
                                  fontWeight: FontWeight.bold, fontSize: 33),
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
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: General(),
                                      type: PageTransitionType.fade));
                                },
                                child: DoctorType(
                                  icon: Icon(
                                    IconlyBold.home,
                                    size: 28,
                                    color: Colormanager.blueicon,
                                  ),
                                  text: 'General',
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: Dentist(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                icon: Icon(
                                  FontAwesomeIcons.tooth,
                                  size: 28,
                                  color: Colormanager.blueicon,
                                ),
                                text: 'dentist',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: Nephrology(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                image: Opacity(
                                    opacity: 0.65,
                                    child: Image.asset(
                                      'assets/images/nephrology.png',
                                      fit: BoxFit.cover,
                                      height: mediaquerry.size.width * 0.09,
                                      width: mediaquerry.size.width * 0.09,
                                    )),
                                text: 'Nephrolo..',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: Neurologists(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                icon: Icon(
                                  FontAwesomeIcons.brain,
                                  color: Colormanager.blueicon,
                                  size: 28,
                                ),
                                text: 'neurol..',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: Nutrition(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                image: Opacity(
                                    opacity: 0.8,
                                    child: Image.asset(
                                        'assets/images/Nutrition.png',
                                        height:
                                            mediaquerry.size.height * 0.037)),
                                text: 'Nutrition',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: Pediatrics(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                icon: Icon(
                                  FontAwesomeIcons.baby,
                                  size: 29,
                                  color: Colormanager.blueicon,
                                ),
                                text: 'pediatri..',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: Cardiologists(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  size: 30,
                                  color: Colormanager.blueicon,
                                ),
                                text: 'Cardiol..',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: SeeAll(),
                                    type: PageTransitionType.fade));
                              },
                              child: DoctorType(
                                icon: Icon(
                                  Icons.more_horiz,
                                  size: 33,
                                  color: Colormanager.blueicon,
                                ),
                                text: 'More',
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        'Top Doctors',
                        style: GoogleFonts.dongle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),

                      SizedBox(
                     
                        height:mediaquerry.size.height*0.32,
                        child: AllDoctorsHorizontal()),
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
}
