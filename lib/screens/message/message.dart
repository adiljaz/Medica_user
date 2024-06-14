import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'chat.dart';  // Ensure you have the ChatPage imported

class Message extends StatelessWidget {
  Message({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
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
    String lastMessage = data['lastMessage'] ?? 'No messages yet';
    String time = data['time'] ?? '';

    if (uid != null && _auth.currentUser!.uid != uid) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(PageTransition(
              child: ChatPage(
                name: name,
                image:profile!,
           
                reciveUserid: uid,
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
              subtitle: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  if (true) // condition to show unread message count
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2', // Unread messages count
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Text('No data available'),
      );
    }
  }
}
 