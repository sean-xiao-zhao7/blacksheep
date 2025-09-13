import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:sheepfold/screens/chat/chat_bubble.dart";
import "package:sheepfold/widgets/layouts/headers/genty_header.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

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
    _loadMessages();
  }

  /// load all chat messages of the current chat
  _loadMessages() async {
    setState(() {
      _isLoading = true;
    });
    String snackMessage = '';
    try {
      DatabaseReference chatsRef = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await chatsRef
          .child('chats/${widget.chatId}')
          .get();
      if (!snapshot.exists) {
        snackMessage = 'Data doesn\'t exist in database.';
      } else {
        Map<dynamic, dynamic> chatData =
            snapshot.value as Map<dynamic, dynamic>;
        print(chatData);
      }
    } catch (error) {
      // print error
      snackMessage = 'Server error, please try again later';
    }

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(snackMessage)));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.only(bottom: 15),
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(top: 5, left: 15, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NowHeader(
                  'Chatting with David',
                  fontSize: 14,
                  color: Color(0xff32a2c0),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 26,
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        // ...
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    IconButton(
                      iconSize: 26,
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // ...
                      },
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: EdgeInsets.all(10),
                    child: ListView(children: [ChatBubble()]),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
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
          ),
        ],
      ),
    );
  }
}
