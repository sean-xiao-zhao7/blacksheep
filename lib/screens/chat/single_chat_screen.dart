import "package:flutter/material.dart";
import 'package:flutter_email_sender/flutter_email_sender.dart';
import "package:firebase_database/firebase_database.dart";

import "package:sheepfold/screens/chat/chat_bubble_widget.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

/// A single chat between 2 parties.
class SingleChat extends StatefulWidget {
  const SingleChat({
    super.key,
    this.chatId = '',
    this.messages = const {},
    this.isMentor = false,
    this.mentorFirstName = '',
    this.menteeFirstName = '',
    this.isAdmin = false,
  });
  final String chatId;
  final Map<dynamic, dynamic> messages;
  final bool isMentor;
  final String mentorFirstName;
  final String menteeFirstName;
  final bool isAdmin;

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

  sendEmail() async {
    final Email email = Email(
      body: "Test body",
      subject: "Test subject",
      recipients: ["john316rocks@gmail.com"],
      isHTML: false,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(platformResponse)));
  }

  void _makeMessagesBubbles() {
    List<ChatBubble> tempBubbles = [];
    for (String key in widget.messages.keys) {
      int timestamp;
      if (widget.messages[key]['timestamp'] is String) {
        timestamp = int.parse(widget.messages[key]['timestamp']);
      } else {
        timestamp = widget.messages[key]['timestamp'];
      }

      ChatBubble currentBubble;
      if (widget.isAdmin) {
        currentBubble = ChatBubble(
          message: widget.messages[key]['message'],
          currentUser: widget.messages[key]['mentee'] ? true : false,
          timestamp: timestamp,
          userName: widget.messages[key]['mentee']
              ? widget.menteeFirstName
              : widget.mentorFirstName,
          isAdmin: true,
        );
      } else {
        currentBubble = ChatBubble(
          message: widget.messages[key]['message'],
          currentUser: widget.messages[key]['mentee'] == !widget.isMentor,
          timestamp: timestamp,
          userName: widget.isMentor ? widget.mentorFirstName : '',
        );
      }
      tempBubbles.add(currentBubble);
    }
    setState(() {
      tempBubbles.sort((a, b) => a.timestamp.compareTo(b.timestamp));
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
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      ChatBubble newChatBubble = ChatBubble(
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

  showChangeMatch() {}

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
                  widget.menteeFirstName.isEmpty
                      ? 'Chatting with ${widget.mentorFirstName}'
                      : '${widget.mentorFirstName} / ${widget.menteeFirstName}',
                  fontSize: 14,
                  color: Color(0xff32a2c0),
                ),
                Row(
                  children: [
                    // IconButton(
                    //   iconSize: 26,
                    //   icon: const Icon(Icons.email),
                    //   onPressed: () {
                    //     sendEmail();
                    //   },
                    //   padding: EdgeInsets.all(0),
                    // ),
                    IconButton(
                      iconSize: 26,
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        _makeMessagesBubbles();
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    MenuAnchor(
                      menuChildren: <Widget>[
                        widget.isAdmin
                            ? MenuItemButton(
                                onPressed: () => {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        widthFactor: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(40),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Choose new mentor for ${widget.menteeFirstName}:',
                                                style: TextStyle(
                                                  color: Color(0xff32a2c0),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                },
                                child: Text('Change matched mentor'),
                              )
                            : MenuItemButton(
                                onPressed: () => {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        widthFactor: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(40),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Report mentor',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                },
                                child: Text('Report mentor'),
                              ),
                      ],
                      builder:
                          (
                            BuildContext context,
                            MenuController controller,
                            Widget? child,
                          ) {
                            return IconButton(
                              iconSize: 26,
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                            );
                          },
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
