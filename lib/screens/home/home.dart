import 'package:fire_login/screens/home/homewidgets/baner.dart';
import 'package:fire_login/screens/home/homewidgets/searchbar.dart';
import 'package:fire_login/screens/home/seeall/seeall.dart';
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        IconlyBold.heart,
                        color: Colormanager.blueicon,
                        size: 30,
                      ),
                    ),
                    const Icon(Icons.notification_add)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // search field
                      GestureDetector(
                        onTap: (){

                          Navigator.of(context).push(PageTransition(child: SearchPage(), type: PageTransitionType.fade));
                        },
                        child: Row(children: [Container(child: Align( 
                          
                          alignment: Alignment.centerLeft, 
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(IconlyLight.search,color:Colormanager.grayText,), SizedBox(width: mediaquerry.size.width*0.03,), 
                                Text('Search',style: GoogleFonts.dongle(fontWeight: FontWeight.w500,fontSize: 28,color: Colormanager.grayText),)
                              ],
                            ),
                          )),width:mediaquerry.size.width*0.89,height: mediaquerry.size.height*0.065, decoration:BoxDecoration(    color:Colormanager.whiteContainer,borderRadius: BorderRadius.circular(8)),)],)
                      ),

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
                        padding: const EdgeInsets.only(left: 7,right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DoctorType(icon: Icon(IconlyBold.home,size: 28,color: Colormanager.blueicon,),text: 'General',),
                            DoctorType(icon: Icon(FontAwesomeIcons.tooth,size: 28,color:  Colormanager.blueicon,),text: 'dentist',),
                            DoctorType(icon: Icon(Icons.visibility,color: Colormanager.blueicon,size: 32  ,),text: 'alooo',),
                            DoctorType( icon: Icon(FontAwesomeIcons.brain,color: Colormanager.blueicon,size: 28, ),text: 'ejnfnrf',),
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7,right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           DoctorType(icon: Icon(Icons.local_drink_sharp ,color: Colormanager.blueicon,),text: 'General',),
                            DoctorType(icon: Icon(Icons.baby_changing_station,color: Colormanager.blueicon,),text: 'dentist',),
                            DoctorType(icon: Icon(Icons.document_scanner_rounded ,color: Colormanager.blueicon,),text: 'alooo',),
                            DoctorType( icon: Icon(Icons.more_horiz,color: Colormanager.blueicon,),text: 'ejnfnrf',),
                          ],

                        ),
                      ),

                       Text('Top Doctors',style: GoogleFonts.dongle(fontWeight: FontWeight.bold,fontSize: 30) ,) ,


                       SizedBox(
                        height: mediaquerry.size.height*0.18,
                        width: mediaquerry.size.width,
                         child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.amber, ),
                          width: mediaquerry.size.width*0.35 ,), 
                         
                          ],
                         ),
                       )

                     
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
