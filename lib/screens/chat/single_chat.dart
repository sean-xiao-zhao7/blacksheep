import "package:flutter/material.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class SingleChat extends StatefulWidget {
  const SingleChat(this.switchScreen, {super.key});
  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _SingleChatState();
  }
}

class _SingleChatState extends State<SingleChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: NowHeader('BlackSheep Chat', color: Colors.black)),
    );
  }
}
