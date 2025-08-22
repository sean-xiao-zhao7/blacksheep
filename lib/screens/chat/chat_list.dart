import "package:flutter/material.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class ChatList extends StatefulWidget {
  const ChatList(this.switchScreen, {super.key});
  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: NowHeader('BlackSheep Home', color: Colors.black)),
      body: SingleChildScrollView(child: Text('Chat List Content')),
    );
  }
}
