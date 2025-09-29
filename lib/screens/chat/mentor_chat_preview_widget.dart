import 'package:flutter/material.dart';

import 'package:sheepfold/screens/chat/single_chat_screen.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  const MentorChatPreviewWidget({super.key, this.chatInfo = const {}});
  final Map<dynamic, dynamic> chatInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => SingleChat(
                messages: chatInfo['messages'],
                chatId: chatInfo['chatId'],
                isMentor: true,
                mentorFirstName: chatInfo['mentorFirstName'],
              ),
            ),
          );
        },
        child: NowHeader("Test 2", color: Colors.black, fontSize: 20),
      ),
    );
  }
}
