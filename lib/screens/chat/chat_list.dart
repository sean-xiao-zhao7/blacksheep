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
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // clear nav stack
    // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);

    return Scaffold(
      appBar: AppBar(
        title: NowHeader('BlackSheep ', color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Text('Welcome ${widget.userData['firstName']} to BlackSheep!'),
      ),
    );
  }
}
