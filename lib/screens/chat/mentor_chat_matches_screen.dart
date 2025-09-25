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
  bool _isLoading = false;
  List<MentorChatPreviewWidget> _chatList = [];

  @override
  void initState() {
    super.initState();
    _makeMentorChatPreviews();
  }

  void _makeMentorChatPreviews() {
    print('here');
    List<MentorChatPreviewWidget> newChatList = [];
    for (Map<dynamic, dynamic> currentChat in widget.myChats) {
      print(currentChat);
      MentorChatPreviewWidget currentBubble = MentorChatPreviewWidget(
        currentChat,
      );
      newChatList.add(currentBubble);
    }
    setState(() {
      // newChatList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      _chatList = newChatList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(children: []),
    );
  }
}
