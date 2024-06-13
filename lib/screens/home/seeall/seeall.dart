import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/screens/home/department/dentist/dentist.dart';
import 'package:fire_login/screens/home/department/general/general.dart';
import 'package:fire_login/screens/home/department/nephrology/nephrology.dart';
import 'package:fire_login/screens/home/department/pediatrics/pediatrics.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:fire_login/screens/home/seeall/drtype.dart';
import 'package:fire_login/screens/home/seeall/seeallwidget/alldoctors.dart';
import 'package:fire_login/screens/home/widgets/doctortype.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final doctor = FirebaseFirestore.instance.collection('doctor');

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return DefaultTabController(

      length: 6,
      child: SafeArea(

        child: Scaffold(
          
          
            appBar: AppBar(
              backgroundColor: Colormanager.scaffold,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    IconlyLight.search,
                    size: 28,
                  ),
                )
              ],
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              title: Text(
                'All Doctors',
                style: GoogleFonts.dongle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),
              ),
              bottom: TabBar(
                  dividerHeight: 0,
                  indicator: BoxDecoration(),
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(left: 10),
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(
                      child: Drtype(
                        typeText: 'All',
                        width: mediaQuery.size.width * 0.15,
                        height: mediaQuery.size.height * 0.045,
                      ),
                    ),
                    Tab(
                      child: Drtype(
                        typeText: 'General',
                        width: mediaQuery.size.width * 0.24,
                        height: mediaQuery.size.height * 0.045,
                      ),
                    ),
                    Tab(
                      child: Drtype(
                        typeText: 'Dentist',
                        width: mediaQuery.size.width * 0.24,
                        height: mediaQuery.size.height * 0.045,
                      ),
                    ),
                    Tab(
                      child: Drtype(
                        typeText: 'Pediatrics',
                        width: mediaQuery.size.width * 0.3,
                        height: mediaQuery.size.height * 0.045,
                      ),
                    ),
                    Tab(
                      child: Drtype(
                        typeText: 'ophthalmologist',
                        width: mediaQuery.size.width * 0.4,
                        height: mediaQuery.size.height * 0.045,
                      ),
                    ),
                    Tab(
                      child: Drtype(
                        typeText: 'Nephrology',
                        width: mediaQuery.size.width * 0.3,
                        height: mediaQuery.size.height * 0.045,
                      ),
                    ),
                  ]),
            ),
            backgroundColor: Colormanager.scaffold,
            body: TabBarView(children: [
              AllDoctors(),
              General(),
              Dentist(),
              Pediatrics(),
              Nephrology(),
              Dentist(),
            ])),
      ),
    );
  }
}
