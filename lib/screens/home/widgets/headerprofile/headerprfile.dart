import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No user data found.'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final userName = userData['name'] ?? 'Unknown User';
        final userImage = userData['imageUrl'];

        return Row(
          children: [
            if (userImage != null && userImage.isNotEmpty)
              CircleAvatar(
                backgroundImage: NetworkImage(userImage),
                radius: 30,
              )
            else
              CircleAvatar(
                child: Icon(Icons.person),
                radius: 30,
              ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have a nice day 👋🏻',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Stream<DocumentSnapshot> _fetchUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.error('No user logged in');
    }

    

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

     

    return userDoc.snapshots();
  }
}
  