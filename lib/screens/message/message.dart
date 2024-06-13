import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/screens/message/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Message extends StatelessWidget {
  Message({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildDoctorList(),
    );
  }

  Widget _buildDoctorList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users auth').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No doctors available'));
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc, context)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document, BuildContext context) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    String? email = data['email'];
    String? uid = data['uid'];

    if (email != null && uid != null && _auth.currentUser!.email != email) {
      return ListTile(
        title: Text(email),
        onTap: () {
          Navigator.of(context).push(PageTransition(
            child: ChatPage(
              reciveuseremail: email,
              reciveUserid: uid,
            ),
            type: PageTransitionType.fade,
          ));
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Text('No data available'),
      );
    }
  }
}
