import 'package:flutter/material.dart';

/// A screen with list of chat previews. Tap on each leads to the single chat screen
class MentorChatMatches extends StatefulWidget {
  const MentorChatMatches({super.key, this.myChats = const {}});
  final Map<dynamic, dynamic> myChats;

  @override
  State<StatefulWidget> createState() {
    return _MentorChatMatchesState();
  }
}

class _MentorChatMatchesState extends State<MentorChatMatches> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
