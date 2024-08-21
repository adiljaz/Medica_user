import 'package:fire_login/screens/message/gemini.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'chat.dart';

class Message extends StatefulWidget {
  Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        title: Text('Messages',
            style: GoogleFonts.dongle(
              textStyle: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Colormanager.blackText),
            )),
        centerTitle: true,
        backgroundColor: Colormanager.scaffold,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),

            //        TextField(

            //   controller: controller,
            //   onChanged: onChanged,
            //   decoration: InputDecoration(

            //     fillColor: Colormanager.whiteContainer,
            //     filled: true,
            //     border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)),
            //     prefixIcon: Icon(icon),
            //     hintText: 'Search doctors...',

            //   ),
            // ),

            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: GeminiAi(), type: PageTransitionType.fade));
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Lottie.asset('assets/lottie/ai.json'),
                      ),
                    )),
                fillColor: Colormanager.whiteContainer,
                filled: true,
                hintText: 'Search doctors...',
                prefixIcon: Icon(Icons.search, color: Colormanager.blueicon),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.all(1),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          _buildHorizontalUserList(),
          Expanded(child: _buildDoctorList()),
        ],
      ),
    );
  }

  Widget _buildHorizontalUserList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('doctor').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                String? uid = data['uid'];
                String? profile = data['imageUrl'];
                String name = data['name'] ?? 'Unknown';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profile != null
                              ? NetworkImage(profile)
                              : AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                        SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colormanager.blackText,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDoctorList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('doctor').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerList();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No doctors available',
                  style: TextStyle(color: Colormanager.blackText)));
        }

        List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String name = (data['name'] ?? '').toLowerCase();
          return name.contains(_searchQuery);
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(
              child: Text('No matching doctors found',
                  style: TextStyle(color: Colormanager.blackText)));
        }

        return AnimationLimiter(
          child: ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildUserListItem(filteredDocs[index], context),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
                title: Container(
                  height: 16,
                  width: 100,
                  color: Colors.grey[300],
                ),
                subtitle: Container(
                  height: 14,
                  width: 150,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
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
              receiveUserId: uid,
            ),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(13, 100, 250, 0.507),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 69, 167, 233).withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Hero(
                  tag: 'profile_$uid',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: profile != null
                            ? NetworkImage(profile)
                            : AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: _getLastMessageStream(uid!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Text('Start a conversation',
                          style: TextStyle(color: Colors.grey[400]));
                    }

                    DocumentSnapshot lastMessage = snapshot.data!.docs.first;
                    Map<String, dynamic> lastMessageData =
                        lastMessage.data() as Map<String, dynamic>;
                    String message =
                        lastMessageData['message'] ?? 'No messages yet';
                    String messageType = lastMessageData['type'] ?? 'text';

                    return Text(
                      messageType == 'image' ? 'Sent an image' : message,
                      style: TextStyle(color: Colors.grey[400]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getLastMessageStream(uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return SizedBox.shrink();
                    }

                    DocumentSnapshot lastMessage = snapshot.data!.docs.first;
                    Map<String, dynamic> lastMessageData =
                        lastMessage.data() as Map<String, dynamic>;
                    Timestamp timestamp =
                        lastMessageData['timestamp'] as Timestamp;
                    DateTime messageTime = timestamp.toDate();

                    String formattedTime = _getFormattedTime(messageTime);

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        formattedTime,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedTime(DateTime messageTime) {
    DateTime now = DateTime.now();
    if (now.difference(messageTime).inDays == 0) {
      return DateFormat('h:mm a').format(messageTime);
    } else if (now.difference(messageTime).inDays < 7) {
      return DateFormat('E').format(messageTime); // Day of week
    } else {
      return DateFormat('MMM d').format(messageTime);
    }
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
