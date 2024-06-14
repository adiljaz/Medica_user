import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> sendMessage(String reciveUserid, String text) async {
    final User? user = FirebaseAuth.instance.currentUser;
    await _firestore.collection('chats').add({
      'senderId': user?.uid,
      'reciveUserid': reciveUserid,
      'messages': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });
  }

  Future<String> sendImage(String reciveUserid, File imageFile) async {
    final User? user = FirebaseAuth.instance.currentUser;
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask = _storage
        .ref()
        .child('chat_images')
        .child(fileName)
        .putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    await _firestore.collection('chats').add({
      'senderId': user?.uid,
      'reciveUserid': reciveUserid,
      'messages': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'image',
    });

    return imageUrl;
  }

  Future<void> deleteMessage(String docId) async {
    await _firestore.collection('chats').doc(docId).delete();
  }

  Stream<QuerySnapshot> getMessages(String reciveUserid, String senderId) {
    return _firestore
        .collection('chats')
        .where('reciveUserid', isEqualTo: reciveUserid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
