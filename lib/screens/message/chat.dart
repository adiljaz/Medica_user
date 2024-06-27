import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/chat/chat_bloc.dart';
import 'package:fire_login/blocs/chat/chat_event.dart';
import 'package:fire_login/blocs/chat/chat_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.receiveUserId,
    required this.image,
    required this.name,
  }) : super(key: key);

  final String receiveUserId;
  final String image;
  final String name;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late ChatBloc _chatBloc;
  List<DocumentSnapshot> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc();
    _chatBloc.add(FetchMessagesEvent(widget.receiveUserId));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _chatBloc.close(); // Close the bloc to avoid memory leaks
    super.dispose();
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;
      _messageController.clear();
      _chatBloc.add(SendMessageEvent(widget.receiveUserId, messageText));
    }
  }

  void sendImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _chatBloc.add(SendImageEvent(widget.receiveUserId, imageFile));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteMessage(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _chatBloc.add(DeleteMessageEvent(docId));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              bloc: _chatBloc,
              listener: (context, state) {
                if (state is ChatMessageSent || state is ChatMessageDeleted) {
                  _chatBloc.add(FetchMessagesEvent(widget.receiveUserId));
                } else if (state is ChatLoaded) {
                  setState(() {
                    _messages = state.messages;
                  });
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = _messages[index];
                    Map<String, dynamic>? data =
                        document.data() as Map<String, dynamic>?;

                    if (data == null) return SizedBox.shrink(); // Skip if data is null

                    // Check if the sender ID matches the current user's ID
                    var isCurrentUser = data['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid;

                    return GestureDetector(
                      onLongPress: () => _deleteMessage(document.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (isCurrentUser) ...[
                              // Message sent by the current user
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['messages'], // Use 'messages' instead of 'message'
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ] else ...[
                              // Message sent by the doctor
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['messages'], // Use 'messages' instead of 'message'
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              '10:30 AM', // Replace with your timestamp logic
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
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
            icon: Icon(Icons.image), // Changed camera icon to image icon
            onPressed: sendImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                suffixIcon: IconButton(
                  // Added send icon inside text field
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 