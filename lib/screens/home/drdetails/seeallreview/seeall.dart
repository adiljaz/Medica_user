import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart'; 

class ReviewS extends StatelessWidget {
  const ReviewS({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colormanager.scaffold,
        centerTitle: true,
        title: Text(
          'Reviews',
          style: GoogleFonts.dongle(fontWeight: FontWeight.bold, fontSize: 33),
        ),
      ),
      backgroundColor: Colormanager.scaffold,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctor')
            .doc(_auth.currentUser!.uid)
            .collection('reviews')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reviews = snapshot.data?.docs ?? [];

          if (reviews.isEmpty) {
            return Center(child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(PageTransition(
                //     child: ReviewPage(
                //       doctorId: widget.uid!,
                //     ),
                //     type: PageTransitionType.fade));
              },
            ));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              String userImage = review['userimage'] ?? '';
              String userName = review['username'] ?? 'Anonymous';
              String userReview = review['review'] ?? '';
              double rating = (review['rating'] as num).toDouble();
              DateTime date = (review['date'] as Timestamp).toDate();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colormanager.whiteContainer,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: userImage.isNotEmpty
                                  ? NetworkImage(userImage)
                                  : null,
                              child: userImage.isEmpty
                                  ? Icon(Icons.person, color: Colors.white)
                                  : null,
                              radius: 25,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy').format(date),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            RatingBarIndicator(
                              rating: rating,
                              itemBuilder: (context, index) =>
                                  Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          userReview,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
