import 'package:flutter/material.dart';
import 'package:sheepfold/widgets/buttons/large_info_button.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  const MentorChatPreviewWidget({
    super.key,
    required this.chatInfo,
    required this.setChatListKey,
    required this.chatPreviewIndex,
    this.showBothNames = false,
  });
  final Map<dynamic, dynamic> chatInfo;
  final Function setChatListKey;
  final bool showBothNames;
  final int chatPreviewIndex;

  @override
  Widget build(BuildContext context) {
    String headerText =
        "${chatInfo['menteeFirstName']} ${chatInfo['menteeLastName']}";
    if (showBothNames) {
      headerText =
          "${chatInfo['mentorFirstName']} with ${chatInfo['menteeFirstName']}";
    }
    return LargeInfoButton(
      headerText: headerText,
      secondaryText:
          'Age ${chatInfo['age']}, ${chatInfo['gender']}. (${chatInfo['phone']})',
      () {
        setChatListKey(chatPreviewIndex);
      },
      iconType: chatInfo['type'],
    );
  }
}
