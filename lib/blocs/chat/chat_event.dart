import 'dart:io';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String reciveUserid;
  final String text;

  SendMessageEvent(this.reciveUserid, this.text);
}

class SendImageEvent extends ChatEvent {
  final String reciveUserid;
  final File imageFile;

  SendImageEvent(this.reciveUserid, this.imageFile);
}

class DeleteMessageEvent extends ChatEvent {
  final String docId;

  DeleteMessageEvent(this.docId);
}

class FetchMessagesEvent extends ChatEvent {
  final String reciveUserid;

  FetchMessagesEvent(this.reciveUserid);
}