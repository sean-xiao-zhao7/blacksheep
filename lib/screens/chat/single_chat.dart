import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:sheepfold/screens/chat/chat_bubble.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class SingleChat extends StatefulWidget {
  const SingleChat({
    super.key,
    this.chatId = '',
    this.messages = const {},
    this.isMentor = false,
  });
  final String chatId;
  final Map<dynamic, dynamic> messages;
  final bool isMentor;

  @override
  State<StatefulWidget> createState() {
    return _SingleChatState();
  }
}

class _SingleChatState extends State<SingleChat> {
  bool _isLoading = true;
  List<Widget> chatBubbles = [];
  TextEditingController newMessageController = TextEditingController();
  final ScrollController _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _makeMessagesBubbles();
  }

  void _makeMessagesBubbles() {
    List<Widget> tempBubbles = [];
    for (String key in widget.messages.keys) {
      Widget currentBubble = ChatBubble(
        message: widget.messages[key]['message'],
        currentUser: widget.messages[key]['mentee'] == !widget.isMentor,
      );
      tempBubbles.add(currentBubble);
    }
    setState(() {
      chatBubbles = tempBubbles;
      _isLoading = false;
    });
  }

  _sendNewMessage() async {
    String snackMessage = '';
    try {
      DatabaseReference chatstRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}/messages",
      );
      DatabaseReference newMessageRef = chatstRef.push();
      await newMessageRef.set({
        'mentee': !widget.isMentor,
        'message': newMessageController.text,
        'datetime': DateTime.now().millisecondsSinceEpoch,
      });
      Widget newChatBubble = ChatBubble(
        message: newMessageController.text,
        currentUser: true,
      );
      setState(() {
        chatBubbles = [...chatBubbles, newChatBubble];
        newMessageController.clear();
      });
      _scrollDown();
    } catch (error) {
      snackMessage = 'Unable to send message, please try again later';
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(snackMessage)));
      }
    }
  }

  void _scrollDown({bool animated = true}) {
    if (animated) {
      _listViewController.animateTo(
        _listViewController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _listViewController.jumpTo(_listViewController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(200, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
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
                      onPressed: () {},
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
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ListView(
                      controller: _listViewController,
                      children: chatBubbles,
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
            child: TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Enter chat message',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Color(0xff32a2c0)),
                  onPressed: () {
                    _sendNewMessage();
                  },
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff32a2c0), width: 1),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Message is required.';
                }
                return null;
              },
              autocorrect: false,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5,
              minLines: 1,
              controller: newMessageController,
            ),
          ),
        ],
      ),
    );
  }
}
