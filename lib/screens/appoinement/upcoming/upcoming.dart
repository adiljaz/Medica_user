


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

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
                                onTap: () {},
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 13,
                                                    top: 12),
                                                child: Text(
                                                  doctor['name'],
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Container(
                                                  width: mediaQuery.size.width *
                                                      0.25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        3,
                                                      ),
                                                      border: Border.all(
                                                          color:
                                                            Colormanager.blueContainer,
                                                          width: 1.5)),
                                                  child: Center(
                                                    child: Text(
                                                      'Upcoming',
                                                      style: GoogleFonts.poppins(
                                                          color:
                                                            Colormanager.blueContainer,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  'Gender :-  add gender ',
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          Colormanager.grayText,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  '''Age:- 12''',
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          Colormanager.grayText,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  'Gender :- male ',
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          Colormanager.grayText,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  '''Desies:- corona ''',
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          Colormanager.grayText,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
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
