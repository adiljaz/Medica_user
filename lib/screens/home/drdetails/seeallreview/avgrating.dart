import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/drdetail/round.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class DoctorRatingWidget extends StatelessWidget {
  final String doctorId;

  const DoctorRatingWidget({Key? key, required this.doctorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctor')
          .doc(doctorId)
          .collection('reviews')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final reviews = snapshot.data?.docs ?? [];
        double averageRating = 0;
        if (reviews.isNotEmpty) {
          double totalRating = reviews.fold(0, (sum, review) => sum + (review['rating'] as num));
          averageRating = totalRating / reviews.length;
        }

        return Column(
          children: [
            DetailsRound(
              icon: Icon(
                IconlyBold.star,
                size: 26,
                color: Colormanager.blueicon,
              ),
            ),
            Text(
              averageRating.toStringAsFixed(1),
              style: GoogleFonts.poppins(
                fontSize: 13,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colormanager.blueText,
                ),
              ),
            ),
            Text(
              'Rating',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            
          ],
        );
      },
    );
  }
}