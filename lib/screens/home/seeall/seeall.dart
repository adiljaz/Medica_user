import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/screens/home/department/department.dart';

import 'package:fire_login/screens/home/seeall/drtype.dart'; 
import 'package:fire_login/screens/home/seeall/seeallwidget/alldoctors.dart';

import 'package:fire_login/screens/search/saech.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart'; 

class SeeAll extends StatefulWidget {
  const SeeAll({Key? key}) : super(key: key);

  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      setState(() {});  
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore.instance.collection('doctor');
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colormanager.scaffold,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                      child: SearchPage(), type: PageTransitionType.fade));
                },
                child: Icon(
                  IconlyLight.search,
                  size: 28,
                ),
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
            controller: _tabController,
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
                  isSelected: _tabController.index == 0,
                ),
              ),
              Tab(
                child: Drtype(
                  typeText: 'General',
                  width: mediaQuery.size.width * 0.24,
                  height: mediaQuery.size.height * 0.045,
                  isSelected: _tabController.index == 1,
                ),
              ),
              Tab(
                child: Drtype(
                  typeText: 'Dentist',
                  width: mediaQuery.size.width * 0.24,
                  height: mediaQuery.size.height * 0.045,
                  isSelected: _tabController.index == 2,
                ),
              ),
              Tab(
                child: Drtype(
                  typeText: 'Pediatrics',
                  width: mediaQuery.size.width * 0.3,
                  height: mediaQuery.size.height * 0.045,
                  isSelected: _tabController.index == 3,
                ),
              ),
              
              Tab(
                child: Drtype(
                  typeText: 'Nephrology',
                  width: mediaQuery.size.width * 0.3,
                  height: mediaQuery.size.height * 0.045,
                  isSelected: _tabController.index == 5,
                ),
              ),
               Tab(
                child: Drtype(
                  typeText: 'Nutrition',
                  width: mediaQuery.size.width * 0.3,
                  height: mediaQuery.size.height * 0.045,
                  isSelected: _tabController.index == 5,
                ),
              ),
              Tab(
                child: Drtype(
                  typeText: 'Cardiologists', 
                  width: mediaQuery.size.width * 0.3,
                  height: mediaQuery.size.height * 0.045,
                  isSelected: _tabController.index == 5,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colormanager.scaffold,
        body: TabBarView(
          controller: _tabController,
          children: [
            AllDoctors(),
            Department(department: 'General'), 
             Department(department: 'Dentist'), 
             Department(department: 'Pediatrics'),  
             Department(department: 'Nephrology'), 
              Department(department: 'Nutrition'), 
                Department(department: 'Cardiologists'), 
             
             
          ],
        ),
      ),
    );
  }
}  