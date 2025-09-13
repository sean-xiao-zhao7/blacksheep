import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";

class SingleChat extends StatefulWidget {
  const SingleChat({super.key, this.chatId = ''});
  final String chatId;

  @override
  State<StatefulWidget> createState() {
    return _SingleChatState();
  }
}

class _SingleChatState extends State<SingleChat> {
  bool _isLoading = false;
  Map<String, dynamic> messages = {};

  @override
  void initState() {
    super.initState();
  }

  /// load all chat messages of the current chat
  _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DatabaseReference chatsRef = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await chatsRef
          .child('chats/${widget.chatId}')
          .get();
      print(snapshot.value);
      // DataSnapshot snapshot = await chatsRef.get();
      // .child('chats/${widget.chatId}/messages')
      // .get();
      // if (!snapshot.exists) {
      //   throw Error();
      //   // 'User with uid ${userInfo.user!.uid} does not exist in database even though it exists in auth.',
      // }
    } catch (error) {
      print(error);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadMessages();
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(children: [Text('Hello!')]),
          ),
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
