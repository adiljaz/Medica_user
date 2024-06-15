// chat_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/chat/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'chat_event.dart';


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

 Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
  try {
    final User? user = _firebaseAuth.currentUser;
    await _firestore.collection('chats').add({
      'senderId': user?.uid,
      'reciveUserid': event.reciveUserid,
      'messages': event.text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });
    emit(ChatMessageSent()); // Emit state after message sent
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}

  Future<void> _onSendImage(SendImageEvent event, Emitter<ChatState> emit) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage
          .ref()
          .child('chat_images')
          .child(fileName)
          .putFile(event.imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore.collection('chats').add({
        'senderId': user?.uid,
        'reciveUserid': event.reciveUserid,
        'messages': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'image',
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
  try {
    await _firestore.collection('chats').doc(event.docId).delete();
    emit(ChatMessageDeleted()); // Emit state after message deletion
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}


  Future<void> _onFetchMessages(FetchMessagesEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      final QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('reciveUserid', isEqualTo: event.reciveUserid)
          .orderBy('timestamp', descending: true)
          .get();
      emit(ChatLoaded(snapshot.docs));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
