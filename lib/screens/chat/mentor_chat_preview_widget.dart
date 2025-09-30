import 'package:flutter/material.dart';
import 'package:sheepfold/widgets/buttons/main_button.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  MentorChatPreviewWidget(
    setChatListKey, {
    super.key,
    this.chatInfo = const {},
  });
  final Map<dynamic, dynamic> chatInfo;
  final ValueChanged<int> setChatListKey = (value) {};

  @override
  Widget build(BuildContext context) {
    return MainButton("Chat with ${chatInfo['mentorFirstName']}", () {
      setChatListKey(10);
    });
  }
}
