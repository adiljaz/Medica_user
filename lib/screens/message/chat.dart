import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/screens/message/chatservice.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.reciveUserid,
    required this.image,
    required this.name,
  }) : super(key: key);

  final String reciveUserid;
  final String image;
  final String name;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.reciveUserid,
        _messageController.text,
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void sendImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });
      File imageFile = File(pickedFile.path);
      await _chatService.sendImage(widget.reciveUserid, imageFile);
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteMessage(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Message'),
        content: Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _chatService.deleteMessage(docId);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colormanager.whiteContainer,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.name,
              style: GoogleFonts.dongle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colormanager.whiteText,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 0, 140, 255),
      ),
      body: Column(
        children: [
          if (_isLoading) LinearProgressIndicator(),
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: sendImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.reciveUserid,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;
        messages.sort((a, b) {
          // Check if timestamps are null and handle accordingly
          if (a['timestamp'] == null || b['timestamp'] == null) {
            return 0; // Consider them equal if either is null
          }
          return a['timestamp'].compareTo(b['timestamp']);
        });
        messages = messages.reversed.toList();

        return ListView.builder(
          reverse:
              true, // Reverse the list view to show latest messages at the bottom
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = messages[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            var isCurrentUser =
                data['senderId'] == _firebaseAuth.currentUser!.uid;

            return GestureDetector(
              onLongPress: () => _deleteMessage(document.id),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                alignment: isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (data['type'] == 'text')
                      ChatBubble(
                        message: data['messages'],
                        isCurrentUser: isCurrentUser,
                        timestamp: data['timestamp']?.toDate(),
                      )
                    else if (data['type'] == 'image')
                      ImageBubble(
                        imageUrl: data['messages'],
                        isCurrentUser: isCurrentUser,
                        timestamp: data['timestamp']?.toDate(),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final DateTime? timestamp;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color:
            isCurrentUser ? Color.fromARGB(255, 0, 140, 255) : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isCurrentUser ? Radius.circular(20) : Radius.circular(0),
          bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black87,
            ),
          ),
          if (timestamp != null)
            Text(
              '${timestamp!.hour}:${timestamp!.minute} ${timestamp!.hour < 12 ? 'AM' : 'PM'}',
              style: TextStyle(
                color: isCurrentUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

class ImageBubble extends StatelessWidget {
  final String imageUrl;
  final bool isCurrentUser;
  final DateTime? timestamp;

  const ImageBubble({
    Key? key,
    required this.imageUrl,
    required this.isCurrentUser,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
            isCurrentUser ? Color.fromARGB(255, 0, 140, 255) : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isCurrentUser ? Radius.circular(20) : Radius.circular(0),
          bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 200, fit: BoxFit.cover),
          if (timestamp != null)
            Text(
              '${timestamp!.hour}:${timestamp!.minute} ${timestamp!.hour < 12 ? 'AM' : 'PM'}',
              style: TextStyle(
                color: isCurrentUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}
