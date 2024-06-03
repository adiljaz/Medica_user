import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:fire_login/screens/home/seeall/drtype.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final doctor = FirebaseFirestore.instance.collection('doctor');

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colormanager.scaffold,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios)),
                  Text(
                    'All Doctors',
                    style: GoogleFonts.dongle(
                        fontWeight: FontWeight.bold, fontSize: 33),
                  ),
                  Icon(IconlyLight.search)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Container(
                height: mediaQuery.size.height * 0.045,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Drtype(
                      typeText: 'All',
                      width: mediaQuery.size.width * 0.16,
                    ),
                    SizedBox(
                      width: mediaQuery.size.height * 0.01,
                    ),
                    Drtype(
                      typeText: 'General',
                      width: mediaQuery.size.width * 0.23,
                    ),
                    SizedBox(
                      width: mediaQuery.size.height * 0.01,
                    ),
                    Drtype(
                      typeText: 'Dentist',
                      width: mediaQuery.size.width * 0.2,
                    ),
                    SizedBox(
                      width: mediaQuery.size.height * 0.01,
                    ),
                    Drtype(
                      typeText: 'Nutritionts',
                      width: mediaQuery.size.width * 0.3,
                    ),     
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: doctor.snapshots(),
              builder: (context, snpashot) {
                if (snpashot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snpashot.hasError) {
                  print('erro');
                }

                if (snpashot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snpashot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doctor = snpashot.data!.docs[index];

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 13, top: 13, right: 13),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(PageTransition(child: , type: PageTransitionType.fade)),
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryanimation) =>
                                        DrDetails(
                                      about: doctor['about'],
                                      departmnet: doctor['department'],
                                      experiance: doctor['experiance'],
                                      fees: doctor['fees'],
                                      from: doctor['form'],
                                      hospital: doctor['hospitalNAme'],
                                      imageUrl: doctor['imageUrl'],
                                      name: doctor['name'],
                                      to: doctor['to'],
                                      uid: doctor['uid'],
                                    ),
                                    transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) =>
                                        Align(
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        child: DrDetails(
                                          about: doctor['about'],
                                          departmnet: doctor['department'],
                                          experiance: doctor['experiance'],
                                          fees: doctor['fees'],
                                          from: doctor['form'],
                                          hospital: doctor['hospitalNAme'],
                                          imageUrl: doctor['imageUrl'],
                                          name: doctor['name'],
                                          to: doctor['to'],
                                          uid: doctor['uid'],
                                        ),
                                      ),
                                    ),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colormanager.whiteContainer,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          top: 15,
                                        ),
                                        child: Container(
                                          height:
                                              mediaQuery.size.height * 0.145,
                                          width: mediaQuery.size.width * 0.3,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                doctor['imageUrl'] ?? '',
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.46,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15),
                                                      child: Text(
                                                        doctor['name'],
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 19),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    IconlyBold.heart,
                                                    color:
                                                        Colormanager.blueicon,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.05,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  width: mediaQuery.size.width *
                                                      0.5,
                                                  child: Divider()),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(doctor['department'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colormanager
                                                                .grayText),
                                                      )),
                                                  Text(
                                                    '|',
                                                    style: TextStyle(
                                                        color: Colormanager
                                                            .grayText,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Text(doctor['hospitalNAme'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colormanager
                                                                .grayText),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    IconlyBold.star,
                                                    color:
                                                        Colormanager.blueicon,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '4.3',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colormanager
                                                            .grayText),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '(3,837 reviews)',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colormanager
                                                            .grayText),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.1,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  height: mediaQuery.size.height * 0.18,
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }

                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
