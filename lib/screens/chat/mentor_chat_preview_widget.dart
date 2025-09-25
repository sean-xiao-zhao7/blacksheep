import 'package:flutter/material.dart';

class MentorChatPreviewWidget extends StatelessWidget {
  const MentorChatPreviewWidget(userName, {super.key});
  final String userName = '';

  @override
  Widget build(BuildContext context) {
    return Text(userName);
  }
}
