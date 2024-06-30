import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatefulWidget {
  final String doctorId;

  const ReviewPage({Key? key, required this.doctorId}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _rating = 0.0;
  String? _userName;
  String? _userImageUrl;
  String? _ratingError;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (userData.docs.isNotEmpty) {
          setState(() {
            _userName = userData.docs[0]['name'];
            _userImageUrl = userData.docs[0]['imageUrl'];
          });
        } else {
          print('User data not found');
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    setState(() {
      _ratingError = _rating == 0 ? 'Please provide a rating' : null;
    });

    if (_formKey.currentState!.validate() && _rating > 0) {
      _uploadReview();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide both a rating and a review')),
      );
    }
  }

  void _uploadReview() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to submit a review')),
        );
        return;
      }

      final reviewData = {
        'userimage': _userImageUrl,
        'username': _userName,
        'uid': user.uid,
        'doctorId': widget.doctorId,
        'review': _reviewController.text,
        'rating': _rating,
        'date': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('doctor')
          .doc(widget.doctorId)
          .collection('reviews')
          .add(reviewData);

      _reviewController.clear();
      setState(() {
        _rating = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
      
        SnackBar(content: Text('Review submitted successfully'),behavior: SnackBarBehavior.floating, padding: EdgeInsets.all(10),backgroundColor: Colormanager.blackIcon,),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Submit Review',
          style: GoogleFonts.dongle(
            textStyle: TextStyle(color: Colormanager.blackText),
            fontWeight: FontWeight.bold,
            fontSize: 33,
          ),
        ),
        backgroundColor: Colormanager.scaffold,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSection(),
                    SizedBox(height: 24),
                    _buildReviewSection(),
                    SizedBox(height: 24),
                    _buildSubmitButton(),
                    SizedBox(height: 32),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      color: Color.fromARGB(255, 223, 241, 255),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Rating',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue)),
            SizedBox(height: 8),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                    _ratingError = null;
                  });
                },
              ),
            ),
            if (_ratingError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _ratingError!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Card(
      color: const Color.fromARGB(255, 231, 243, 253),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Review',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue)),
            SizedBox(height: 8),
            TextFormField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Write your review here',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.rate_review, color: Colors.blue),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your review';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitReview,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('Submit Review',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 18, color: Colors.white))),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colormanager.blueicon,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}