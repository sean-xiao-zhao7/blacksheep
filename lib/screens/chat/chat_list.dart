import "package:flutter/material.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class ChatList extends StatefulWidget {
  const ChatList(this.userData, {super.key});
  final Map<String, String> userData;

  @override
  State<StatefulWidget> createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: NowHeader('BlackSheep ', color: Colors.black)),
      body: SingleChildScrollView(
        child: Text('Welcome ${widget.userData['firstName']} to BlackSheep!'),
      ),
    );
  }
}
