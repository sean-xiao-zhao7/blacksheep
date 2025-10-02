import 'package:flutter/material.dart';
import 'package:sheepfold/widgets/buttons/main_button.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  const MentorChatPreviewWidget({
    super.key,
    required this.chatInfo,
    required this.setChatListKey,
    this.showBothNames = false,
  });
  final Map<dynamic, dynamic> chatInfo;
  final Function setChatListKey;
  final bool showBothNames;

  @override
  Widget build(BuildContext context) {
    String finalText = "Chat with ${chatInfo['mentorFirstName']}";
    if (showBothNames) {
      finalText =
          "${chatInfo['mentorFirstName']} with ${chatInfo['menteeFirstName']}";
    }
    return MainButton(finalText, () {
      setChatListKey();
    });
  }
}
