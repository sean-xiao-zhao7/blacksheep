import "package:flutter/material.dart";

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
        color: const Color.fromARGB(240, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Expanded(child: ListView(children: [Text('Hello!')])),
          TextFormField(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter chat message',
              suffixIcon: Icon(Icons.send, color: Color(0xff32a2c0)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First name is required.';
              }
              return null;
            },
            autocorrect: false,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            minLines: 1,
          ),
        ],
      ),
    );
  }
}
