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
  final int chatPreviewIndex;
  final bool showBothNames;

  @override
  Widget build(BuildContext context) {
    Color secondaryTextColor = Color(0xff32a2c0);
    String headerText =
        "${chatInfo['menteeFirstName']} ${chatInfo['menteeLastName']}";
    String secondaryText = '${chatInfo['gender']}. Age ${chatInfo['age']}';

    if (showBothNames) {
      headerText =
          "${chatInfo['mentorFirstName']} ${chatInfo['mentorLastName'].substring(0, 1)}. / ${chatInfo['menteeFirstName']} ${chatInfo['menteeLastName'].substring(0, 1)}.";
      secondaryText = '';
      if (!chatInfo['approved']) {
        secondaryText = 'PENDING APPROVAL';
      }
    }

    if (chatInfo['disabled']) {
      secondaryText = 'CONNECTION DISABLED';
      secondaryTextColor = Colors.red;
    }

    return LargeInfoButton(
      headerText: headerText,
      secondaryText: secondaryText,
      secondaryTextColor: secondaryTextColor,
      () {
        setChatListKey(chatPreviewIndex);
      },
      iconType: chatInfo['type'],
    );
  }
}
