import 'package:flutter/material.dart';
import 'package:sheepfold/widgets/buttons/main_button.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  const MentorChatPreviewWidget({
    super.key,
    required this.chatInfo,
    required this.setChatListKey,
  });
  final Map<dynamic, dynamic> chatInfo;
  final Function(int) setChatListKey;

  @override
  Widget build(BuildContext context) {
    return MainButton("Chat with ${chatInfo['mentorFirstName']}", () {
      setChatListKey(10);
    });
  }
}
