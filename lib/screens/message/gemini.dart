import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fire_login/blocs/gemini/gemini_bloc.dart';
import 'package:fire_login/blocs/gemini/gemini_event.dart';
import 'package:fire_login/blocs/gemini/gemini_state.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class GeminiAi extends StatelessWidget {
  const GeminiAi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GeminiBloc(),
      child: const GeminiAiView(),
    );
  }
}

class GeminiAiView extends StatelessWidget {
  const GeminiAiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colormanager.blueContainer,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colormanager.blackIcon,
          ),
        ),
        centerTitle: true,
        title: const Text('Chat with Gemini'),
        titleTextStyle:
            GoogleFonts.dongle(fontWeight: FontWeight.bold, fontSize: 32),
        elevation: 0,
      ),
      body: _buildUi(context),
    );
  }

  Widget _buildUi(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colormanager.blueContainer, Colors.white],
        ),
      ),
      child: BlocBuilder<GeminiBloc, GeminiState>(
        builder: (context, state) {
          return DashChat(
            inputOptions: InputOptions(
              trailing: [],
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
            currentUser: context.read<GeminiBloc>().currentUser,
            onSend: (ChatMessage message) {
              context.read<GeminiBloc>().add(SendMessage(message));
            },
            messages: state.messages,
            messageOptions: MessageOptions(
              containerColor: Colors.deepPurple.shade50,
              textColor: Colors.black87,
            ),
          );
        },
      ),
    );
  }
}