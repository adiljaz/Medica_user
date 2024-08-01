import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:shimmer/shimmer.dart';

class Department extends StatelessWidget {
  const Department({super.key, required this.department});

  final String department;

  Future<Map<String, dynamic>> _getDoctorRatingAndReviews(String doctorId) async {
    QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(doctorId)
        .collection('reviews')
        .get();

    int reviewCount = reviewsSnapshot.docs.length;
    double totalRating = 0;

    for (var doc in reviewsSnapshot.docs) {
      totalRating += (doc['rating'] as num).toDouble();
    }

    double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

    return {
      'reviewCount': reviewCount,
      'averageRating': averageRating,
    };
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colormanager.scaffold,
        body: Column(
          children: [
            StreamBuilder(
              stream: _firestore
                  .collection('doctor')
                  .where('department', isEqualTo: department)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colormanager.blueContainer),
                  );
                }

                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                    child: Text('Error loading doctors', style: TextStyle(color: Colormanager.errorColor)),
                  );
                }

                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doctor = snapshot.data!.docs[index];

                        return Padding(
                          padding: const EdgeInsets.only(left: 13, top: 13, right: 13),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryanimation) => DrDetails(
                                  about: doctor['about'],
                                  departmnet: doctor['department'],
                                  experiance: doctor['experiance'],
                                  fees: doctor['fees'],
                                  from: doctor['form'],
                                  hospital: doctor['hospitalNAme'],
                                  imageUrl: doctor['imageUrl'],
                                  name: doctor['name'],
                                  to: doctor['to'],
                                  uid: doctor.id,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) => Align(
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    child: child,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 15),
                                    child: Container(
                                      height: mediaQuery.size.height * 0.145,
                                      width: mediaQuery.size.width * 0.3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          doctor['imageUrl'] ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: mediaQuery.size.width * 0.46,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 15),
                                                  child: Text(
                                                    doctor['name'],
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 19,
                                                      color: Colormanager.blackText,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                IconlyBold.heart,
                                                color: Colormanager.blueicon,
                                              ),
                                              SizedBox(width: mediaQuery.size.width * 0.05),
                                            ],
                                          ),
                                          SizedBox(width: mediaQuery.size.width * 0.5, child: Divider()),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                doctor['department'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colormanager.grayText,
                                                ),
                                              ),
                                              Text(
                                                '|',
                                                style: TextStyle(
                                                  color: Colormanager.grayText,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                doctor['hospitalNAme'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colormanager.grayText,
                                                ),
                                              ),
                                            ],
                                          ),
                                          FutureBuilder<Map<String, dynamic>>(
                                            future: _getDoctorRatingAndReviews(doctor.id),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return _buildRatingShimmer();
                                              }
                                              if (snapshot.hasError || !snapshot.hasData) {
                                                return Text('Error loading rating', style: TextStyle(color: Colormanager.errorColor));
                                              }
                                              final data = snapshot.data!;
                                              return Row(
                                                children: [
                                                  Icon(
                                                    IconlyBold.star,
                                                    color: Colormanager.blueicon,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    data['averageRating'].toStringAsFixed(1),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colormanager.grayText,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '(${data['reviewCount']} reviews)',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colormanager.grayText,
                                                    ),
                                                  ),
                                                  SizedBox(width: mediaQuery.size.width * 0.1)
                                                ],
                                              );
                                            },
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
                        );
                      },
                    ),
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

  Widget _buildRatingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Container(width: 24, height: 24, color: Colors.white),
          Spacer(),
          Container(width: 30, height: 16, color: Colors.white),
          Spacer(),
          Container(width: 100, height: 16, color: Colors.white),
        ],
      ),
    );
  }
} 