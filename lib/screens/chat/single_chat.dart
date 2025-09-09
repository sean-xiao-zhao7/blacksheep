import "package:flutter/material.dart";
import "package:sheepfold/widgets/buttons/main_button.dart";

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Expanded(child: ListView(children: [Text('Dummy chat')])),
          MainButton('Connect by chat app', () => {}, size: 400),
        ],
      ),
    );
  }
}
