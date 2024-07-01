import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart'; // Ensure this import points to your ChatPage

class Message extends StatelessWidget {
  Message({Key? key}) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
      stream: _firestore.collection('doctor').snapshots(),
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
          children: snapshot.data!.docs.map((doc) => _buildUserListItem(doc, context)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document, BuildContext context) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    String? uid = data['uid'];
    String? profile = data['imageUrl'];
    String name = data['name'] ?? 'Unknown';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatPage(
              name: name,
              image: profile!,
              receiveUserId: uid!,
            ),
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
                      color: Colors.green,
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
              stream: _getLastMessageStream(uid!),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No messages yet');
                }

                DocumentSnapshot lastMessage = snapshot.data!.docs.first;
                Map<String, dynamic> lastMessageData = lastMessage.data() as Map<String, dynamic>;
                String message = lastMessageData['message'] ?? 'No messages yet';
                String messageType = lastMessageData['type'] ?? 'text';

                return Text(
                  messageType == 'image' ? 'Image' : message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            trailing: StreamBuilder<QuerySnapshot>(
              stream: _getLastMessageStream(uid),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SizedBox.shrink();
                }

                DocumentSnapshot lastMessage = snapshot.data!.docs.first;
                Map<String, dynamic> lastMessageData = lastMessage.data() as Map<String, dynamic>;
                Timestamp timestamp = lastMessageData['timestamp'] as Timestamp;
                DateTime messageTime = timestamp.toDate();

                String formattedTime = DateFormat('h:mm a').format(messageTime);

                return Text(
                  formattedTime,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getLastMessageStream(String doctorUid) {
    String currentUserUid = _auth.currentUser!.uid;
    String chatId = _getChatId(currentUserUid, doctorUid);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots(); 
  }

  String _getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }
}