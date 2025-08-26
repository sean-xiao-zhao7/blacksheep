import "package:flutter/material.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class SingleChat extends StatefulWidget {
  const SingleChat({super.key});

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
      body: Center(child: NowHeader('Single Chat Content')),
    );
  }
}
