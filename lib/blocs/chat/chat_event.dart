import 'dart:io';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String receiveUserId;
  final String text;

  SendMessageEvent(this.receiveUserId, this.text);
}

class SendImageEvent extends ChatEvent {
  final String receiveUserId;
  final File imageFile;

  SendImageEvent(this.receiveUserId, this.imageFile);
}

class DeleteMessageEvent extends ChatEvent {
  final String chatId;
  final String docId;

  DeleteMessageEvent(this.chatId, this.docId);
}

class FetchMessagesEvent extends ChatEvent {
  final String receiveUserId;

  FetchMessagesEvent(this.receiveUserId);
}
