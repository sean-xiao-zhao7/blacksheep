import 'package:flutter/material.dart';
import 'package:blacksheep/widgets/buttons/large_info_button.dart';

class ChatPreviewWidget extends StatelessWidget {
  const ChatPreviewWidget({
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
    String secondaryText =
        'Age ${chatInfo['age']}, ${chatInfo['gender']}. (${chatInfo['phone']})';

    if (showBothNames) {
      headerText =
          "${chatInfo['mentorFirstName']} / ${chatInfo['menteeFirstName']}";
      secondaryText = '';
      if (!chatInfo['approved']) {
        secondaryText = 'PENDING APPROVAL';
      }
    }

    return LargeInfoButton(
      headerText: headerText,
      secondaryText: secondaryText,
      secondaryTextColor: Colors.red,
      () {
        setChatListKey(chatPreviewIndex);
      },
      iconType: chatInfo['type'],
    );
  }
}
