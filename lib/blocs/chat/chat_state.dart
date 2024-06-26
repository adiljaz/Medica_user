import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatMessageSent extends ChatState {}

class ChatMessageDeleted extends ChatState {}

class ChatLoaded extends ChatState {
  final List<DocumentSnapshot> messages;

  ChatLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String errorMessage;

  ChatError(this.errorMessage);
}
