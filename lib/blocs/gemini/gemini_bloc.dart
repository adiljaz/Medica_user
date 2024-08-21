import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:typed_data';
import 'gemini_event.dart';
import 'gemini_state.dart';

class GeminiBloc extends Bloc<GeminiEvent, GeminiState> {
  final Gemini gemini = Gemini.instance;
  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: 'assets/images/images.png',
  );

  GeminiBloc() : super(const GeminiState()) {
    on<SendMessage>(_onSendMessage);
  }

  void _onSendMessage(SendMessage event, Emitter<GeminiState> emit) async {
    final updatedMessages = [event.message, ...state.messages];
    emit(state.copyWith(messages: updatedMessages, isLoading: true));

    try {
      String question = event.message.text;
      List<Uint8List>? images;

      await for (final geminiEvent
          in gemini.streamGenerateContent(question, images: images)) {
        String response = _extractTextFromParts(geminiEvent.content?.parts);

        ChatMessage? lastMessage = state.messages.isNotEmpty ? state.messages.first : null;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = ChatMessage(
            user: lastMessage.user,
            createdAt: lastMessage.createdAt,
            text: lastMessage.text + response,
          );
          final newMessages = [lastMessage, ...state.messages.sublist(1)];
          emit(state.copyWith(messages: newMessages));
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          emit(state.copyWith(messages: [message, ...state.messages]));
        }
      }
    } catch (e) {
      print("Error: $e");
      // You might want to emit an error state here
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  String _extractTextFromParts(List<Parts>? parts) {
    if (parts == null) return "";
    return parts.fold("", (previous, part) => previous + (part.text ?? ""));
  }
} 