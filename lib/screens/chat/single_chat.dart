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
          Expanded(child: ListView(children: [Text('Dummy chat')])),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Enter chat message',
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First name is required.';
              }
              return null;
            },
            autocorrect: false,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
