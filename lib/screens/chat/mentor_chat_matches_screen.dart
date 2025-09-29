import 'package:flutter/material.dart';

import 'package:sheepfold/screens/chat/mentor_chat_preview_widget.dart';

/// A screen with list of chat previews. Tap on each leads to the single chat screen
class MentorChatMatchesScreen extends StatefulWidget {
  const MentorChatMatchesScreen({super.key, this.myChats = const []});
  final List<dynamic> myChats;

  @override
  State<StatefulWidget> createState() {
    return _MentorChatMatchesState();
  }
}

class _MentorChatMatchesState extends State<MentorChatMatchesScreen> {
  List<MentorChatPreviewWidget> _chatList = [];

  @override
  void initState() {
    super.initState();
    _makeMentorChatPreviews();
  }

  void _makeMentorChatPreviews() {
    List<MentorChatPreviewWidget> newChatList = [];
    for (Map<dynamic, dynamic> currentChat in widget.myChats) {
      MentorChatPreviewWidget currentChatPreview = MentorChatPreviewWidget(
        chatInfo: currentChat,
      );
      newChatList.add(currentChatPreview);
    }
    setState(() {
      _chatList = newChatList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(children: _chatList),
    );
  }
}
