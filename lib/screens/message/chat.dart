import 'dart:io';
import 'package:fire_login/blocs/chat/chat_bloc.dart';
import 'package:fire_login/blocs/chat/chat_event.dart';
import 'package:fire_login/blocs/chat/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _chatBloc.close();
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

  void captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _chatBloc.add(SendImageEvent(widget.receiveUserId, imageFile));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
              _chatBloc.add(DeleteMessageEvent(widget.receiveUserId, docId));
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
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.black),
            onPressed: () {/* Implement voice call */},
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.black),
            onPressed: () {/* Implement video call */},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
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
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = _messages[index];
                      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                      if (data == null || data.isEmpty) {
                        return SizedBox.shrink();
                      }

                      var isCurrentUser = data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
                      var messageType = data['type'];
                      var messageContent = data['message'];
                      var timestamp = data['timestamp'] as Timestamp?;
                      var messageTime = timestamp != null
                          ? DateFormat('h:mm a').format(timestamp.toDate())
                          : '';

                      // Add date header
                      Widget? dateHeader;
                      if (index == _messages.length - 1 || 
                          !isSameDay(timestamp, _messages[index + 1]['timestamp'] as Timestamp?)) {
                        dateHeader = _buildDateHeader(timestamp);
                      }

                      return Column(
                        children: [
                          if (dateHeader != null) dateHeader,
                          GestureDetector(
                            onLongPress: () => _deleteMessage(document.id),
                            child: Align(
                              alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (messageType == 'text')
                                      Text(
                                        messageContent ?? '',
                                        style: TextStyle(color: isCurrentUser ? Colors.black : Colors.black),
                                      )
                                    else if (messageType == 'image')
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          messageContent ?? '',
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      messageTime,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(Timestamp? timestamp) {
    if (timestamp == null) return SizedBox.shrink();
    
    final date = timestamp.toDate();
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    String dateText;
    if (isSameDay(timestamp, Timestamp.fromDate(now))) {
      dateText = 'Today';
    } else if (isSameDay(timestamp, Timestamp.fromDate(yesterday))) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMMM d, y').format(date);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            dateText,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  bool isSameDay(Timestamp? date1, Timestamp? date2) {
    if (date1 == null || date2 == null) return false;
    final d1 = date1.toDate();
    final d2 = date2.toDate();
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.blue),
            onPressed: captureImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.photo, color: Colors.blue),
            onPressed: sendImage,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
} 