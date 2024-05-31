import 'package:fire_login/screens/home/homewidgets/baner.dart';
import 'package:fire_login/screens/home/homewidgets/searchbar.dart';
import 'package:fire_login/screens/home/seeall/seeall.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
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
                    Column(
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
                    const Spacer(),
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
                    children: [

                      // search field,

                      Searchfield(
                        controller: _searchController,
                        icons: const Icon(IconlyLight.search,),
                        value: (value) {},
                      ),

                      SizedBox(
                        height: mediaquerry.size.width*0.06,
                      ),

                      /// banner 

                      const BannerImage(),

                      Padding(
                        padding: const EdgeInsets.only(left: 4,right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Doctor Speciality',style: GoogleFonts.dongle(fontWeight: FontWeight.bold,fontSize: 33),),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(PageTransition(child: const SeeAll(), type:PageTransitionType.fade));
                              },
                              child: Text('See All',style: GoogleFonts.dongle(fontWeight: FontWeight.bold,color: Colormanager.blueContainer,fontSize: 25),)),
                              
                          ],
                        ),
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
}
