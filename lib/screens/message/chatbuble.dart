import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';

class ChatBuble extends StatelessWidget {
  final String messsage;
  const ChatBuble({super.key, required this.messsage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colormanager.blueContainer,
          borderRadius: BorderRadius.circular(8)),
          child: Text(messsage,style:TextStyle(fontSize: 16,color: Colormanager.whiteText) ,),
    );
  }
}
