import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendImageEvent>(_onSendImage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<FetchMessagesEvent>(_onFetchMessages);
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      final chatId = _getChatId(user!.uid, event.receiveUserId);

      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': user.uid,
        'message': event.text,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      emit(ChatMessageSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onSendImage(SendImageEvent event, Emitter<ChatState> emit) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      final chatId = _getChatId(user!.uid, event.receiveUserId);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      UploadTask uploadTask = _storage
          .ref()
          .child('images')
          .child(user.uid)
          .child(chatId)
          .child(fileName)
          .putFile(event.imageFile);

      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': user.uid,
        'message': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'image',
      });

      emit(ChatMessageSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      final chatId = _getChatId(user!.uid, event.chatId);

      await _firestore.collection('chats').doc(chatId).collection('messages').doc(event.docId).delete();
      emit(ChatMessageDeleted());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onFetchMessages(FetchMessagesEvent event, Emitter<ChatState> emit) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      final chatId = _getChatId(user!.uid, event.receiveUserId);

      QuerySnapshot querySnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      List<DocumentSnapshot> messages = querySnapshot.docs;
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  String _getChatId(String userId, String otherUserId) {
    List<String> participants = [userId, otherUserId]..sort();
    return participants.join('_');
  }
}
