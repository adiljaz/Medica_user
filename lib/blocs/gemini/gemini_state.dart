import 'package:dash_chat_2/dash_chat_2.dart';

class GeminiState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const GeminiState({
    this.messages = const [],
    this.isLoading = false,
  });

  GeminiState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return GeminiState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}