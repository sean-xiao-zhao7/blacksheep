import 'package:flutter/material.dart';

import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  const MentorChatPreviewWidget({super.key, this.chatInfo = const {}});
  final Map<dynamic, dynamic> chatInfo;

  @override
  Widget build(BuildContext context) {
    print(chatInfo['menteeFirstName']);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: NowHeader("Test 2", color: Colors.black, fontSize: 20),
    );
  }
}
