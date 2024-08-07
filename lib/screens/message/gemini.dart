import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GeminiAi extends StatefulWidget {
  const GeminiAi({super.key});

  @override
  State<GeminiAi> createState() => _HomeState();
}

class _HomeState extends State<GeminiAi> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1", firstName: "Gemini", profileImage: 'assets/images/images.png'); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(   
       backgroundColor: Colormanager.blueContainer,

       
       
        
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios,color: Colormanager.blackIcon,)),
        centerTitle: true,
        title: const Text(' Chat with Gemini ',),
        titleTextStyle:GoogleFonts.dongle(fontWeight: FontWeight.bold,fontSize: 32),
         
        elevation: 0,
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colormanager.blueContainer, Colors.white], 
        ),
      ),
      child: DashChat(
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              onPressed: _sendMediaMessage,
              icon: const Icon(Icons.image, color: Colors.deepPurple),
            )
          ],
          inputDecoration: InputDecoration(
            hintText: "Ask Gemini something...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        messageOptions: MessageOptions(
          containerColor: Colors.deepPurple.shade50,
          textColor: Colors.black87,
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [await _getImageBytes(chatMessage.medias!.first.url)];
      }

      await for (final event in gemini.streamGenerateContent(question, images: images)) {
        ChatMessage? lastMessage = messages.firstOrNull;
        String response = _extractTextFromParts(event.content?.parts);
        
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          lastMessage.text += response;

          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);

          setState(() {
            messages = [message, ...messages];
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  String _extractTextFromParts(List<Parts>? parts) {
    if (parts == null) return "";
    return parts.fold("", (previous, part) => previous + (part.text ?? ""));
  }

  Future<Uint8List> _getImageBytes(String imagePath) async {
    if (imagePath.startsWith('http')) {
      final response = await http.get(Uri.parse(imagePath));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } else {
      return await File(imagePath).readAsBytes();
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "Describe this picture",
          medias: [
            ChatMedia(url: file.path, fileName: file.name, type: MediaType.image),
          ]);
      _sendMessage(chatMessage);
    }
  }
}      