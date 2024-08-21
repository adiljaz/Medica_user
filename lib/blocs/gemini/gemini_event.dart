import 'package:dash_chat_2/dash_chat_2.dart';

abstract class GeminiEvent {}

class SendMessage extends GeminiEvent {
  final ChatMessage message;

  SendMessage(this.message);
}