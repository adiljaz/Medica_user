import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart'; // Ensure you have the ChatPage imported

class Message extends StatelessWidget {
  Message({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chats', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Implement more options
            },
          ),
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: _buildDoctorList(),
    );
  }

  Widget _buildDoctorList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctor').snapshots(),
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

    String? uid = data['uid'];
    String? profile = data['imageUrl'];
    String name = data['name'] ?? 'Unknown';
    String time = data['time'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageTransition(
            child: ChatPage(
              name: name,
              image: profile!,
              receiveUserId: uid!,
            ),
            type: PageTransitionType.fade,
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 189, 206, 251),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: profile != null
                      ? NetworkImage(profile)
                      : AssetImage('assets/default_avatar.png') as ImageProvider,
                  radius: 25,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green, // Online status indicator
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('reciveUserid', isEqualTo: uid)
                  .orderBy('timestamp', descending: true)
                  .limit(1) // Limit to the last message
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No messages yet');
                }

                DocumentSnapshot lastMessage = snapshot.data!.docs.first;
                Map<String, dynamic> lastMessageData = lastMessage.data() as Map<String, dynamic>;
                String message = lastMessageData['messages'] ?? 'No messages yet';

                return Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
 