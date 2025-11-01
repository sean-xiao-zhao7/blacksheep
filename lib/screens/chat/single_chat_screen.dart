import "package:blacksheep/widgets/buttons/small_button_flexible.dart";
import "package:flutter/material.dart";

import "package:firebase_database/firebase_database.dart";

import "package:blacksheep/widgets/chat/chat_bubble_widget.dart";
import "package:blacksheep/services/email_service.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";

/// A single chat between 2 parties.
class SingleChat extends StatefulWidget {
  const SingleChat({
    super.key,
    this.chatId = '',
    this.messages = const {},
    this.isMentor = false,
    this.mentorFirstName = '',
    this.mentorLastName = '',
    this.mentorUid = '',
    this.menteeFirstName = '',
    this.menteeLastName = '',
    this.isAdmin = false,
    this.isPhone = false,
    this.isApproved = false,
    required this.setChatListKey,
  });
  final String chatId;
  final Map<dynamic, dynamic> messages;
  final bool isMentor;
  final String mentorFirstName;
  final String mentorLastName;
  final String mentorUid;
  final String menteeFirstName;
  final String menteeLastName;
  final bool isAdmin;
  final bool isPhone;
  final bool isApproved;
  final Function setChatListKey;

  @override
  State<StatefulWidget> createState() {
    return _SingleChatState();
  }
}

class _SingleChatState extends State<SingleChat> {
  bool _isLoading = true;
  TextEditingController newMessageController = TextEditingController();
  TextEditingController reportMessageController = TextEditingController();
  final ScrollController _listViewController = ScrollController();
  List<Widget> chatBubbles = [];
  List<dynamic> _mentorsSelectionList = [];
  String _newMentorUid = '';

  @override
  void initState() {
    super.initState();
    _makeMessagesBubbles();
    if (widget.isAdmin) {
      _getAllMentors();
    }
  }

  _getAllMentors() async {
    String snackMessage = 'Server error while getting mentors for admin.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("users").get();
      if (!snapshot.exists) {
        return;
      }
      Map<dynamic, dynamic> allUsers = snapshot.value as Map<dynamic, dynamic>;

      List<dynamic> newMentorsSelectionList = [];
      for (final String key in allUsers.keys) {
        var currentUser = allUsers[key];
        if (currentUser['type'] == 'mentor') {
          newMentorsSelectionList.add({
            'uid': key,
            'firstName': currentUser['firstName'],
            'lastName': currentUser['lastName'],
          });

          if (key == widget.mentorUid) {
            setState(() {
              _newMentorUid = key;
            });
          }
        }
      }
      setState(() {
        _mentorsSelectionList = newMentorsSelectionList;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(snackMessage)));
      }
    }
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
          isCurrentUser: widget.messages[key]['mentee'] ? true : false,
          timestamp: timestamp,
          userName: widget.messages[key]['mentee']
              ? "${widget.menteeFirstName} ${widget.menteeLastName}"
              : "${widget.mentorFirstName} ${widget.mentorLastName}",
          isAdmin: true,
        );
      } else {
        currentBubble = ChatBubble(
          message: widget.messages[key]['message'],
          isCurrentUser: widget.messages[key]['mentee'] == !widget.isMentor,
          timestamp: timestamp,
          userName: widget.messages[key]['mentee']
              ? "${widget.menteeFirstName} ${widget.menteeLastName}"
              : "${widget.mentorFirstName} ${widget.mentorLastName}",
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
        isCurrentUser: true,
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

  _changeMentor(String newMentorUid) async {
    String snackMessage = '';
    try {
      DatabaseReference chatstRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}",
      );
      var newMentor = _mentorsSelectionList.firstWhere(
        (mentor) => mentor['uid'] == newMentorUid,
      );
      // print(newMentor);
      await chatstRef.update({
        'mentorFirstName': newMentor['firstName'],
        'mentorLastName': newMentor['lastName'],
        'mentorUid': newMentorUid,
      });
      snackMessage = 'Updated mentor successfully.';
    } catch (error) {
      snackMessage = 'Unable to change mentor, please try again later';
    }

    if (mounted && snackMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(snackMessage)));
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

  _reportMentor() {
    setState(() {
      _isLoading = true;
    });
    final recipient = ['contact.us.blacksheep@gmail.com'];
    final subject = 'Mentor reported by mentee';
    final emailBody =
        'Mentee ${widget.menteeFirstName} has reported ${widget.mentorFirstName}\n\n${reportMessageController.text}';
    EmailService.sendEmail(recipient, subject, emailBody).then(
      (value) => {
        setState(() {
          _isLoading = false;
        }),
      },
    );
  }

  void approveConnection() async {
    String resultMessage = '';
    try {
      DatabaseReference chatstRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}",
      );
      await chatstRef.update({'approved': true});
      resultMessage = 'Approved connection!';
      widget.setChatListKey(-1);
      // App Alert - New Matchup Available - Please Login
      // App Alert - New Matchup Available - Check your Emails
    } catch (error) {
      // print(error);
      resultMessage = 'Server error.';
    }

    if (mounted && resultMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(resultMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];
    if (widget.isAdmin) {
      columnChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SmallButtonFlexible(
              text: widget.isApproved ? 'Approved' : 'Approve',
              handler: approveConnection,
              forgroundColor: widget.isApproved
                  ? Color(0xff32a2c0)
                  : Colors.red,
              isEnabled: !widget.isApproved,
            ),
            SmallButtonFlexible(
              text: 'Change Mentor',
              handler: () => {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
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
                            StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                return DropdownButton<String>(
                                  value: _newMentorUid,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _newMentorUid = value!;
                                    });
                                    _changeMentor(value!);
                                  },
                                  items: _mentorsSelectionList.map((
                                    currentMentor,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: currentMentor['uid'],
                                      child: Text(
                                        "${currentMentor['firstName']} ${currentMentor['lastName']}",
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      );
      columnChildren.add(SizedBox(height: 10));
    }

    columnChildren.add(
      Expanded(
        child: Container(
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
                          ? 'Chatting with ${widget.mentorFirstName} ${widget.mentorLastName}'
                          : '${widget.mentorFirstName} ${widget.mentorLastName} | ${widget.menteeFirstName} ${widget.menteeLastName}',
                      fontSize: 14,
                      color: Color(0xff32a2c0),
                    ),
                    Row(
                      children: [
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
                                                  StatefulBuilder(
                                                    builder:
                                                        (
                                                          BuildContext context,
                                                          setState,
                                                        ) {
                                                          return DropdownButton<
                                                            String
                                                          >(
                                                            value:
                                                                _newMentorUid,
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                            ),
                                                            elevation: 16,
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                            underline: Container(
                                                              height: 2,
                                                              color: Colors
                                                                  .deepPurpleAccent,
                                                            ),
                                                            onChanged:
                                                                (
                                                                  String? value,
                                                                ) {
                                                                  setState(() {
                                                                    _newMentorUid =
                                                                        value!;
                                                                  });
                                                                  _changeMentor(
                                                                    value!,
                                                                  );
                                                                },
                                                            items: _mentorsSelectionList.map((
                                                              currentMentor,
                                                            ) {
                                                              return DropdownMenuItem<
                                                                String
                                                              >(
                                                                value:
                                                                    currentMentor['uid'],
                                                                child: Text(
                                                                  "${currentMentor['firstName']} ${currentMentor['lastName']}",
                                                                ),
                                                              );
                                                            }).toList(),
                                                          );
                                                        },
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
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText:
                                                          'Please explain reason for reporting.',
                                                      suffixIcon: _isLoading
                                                          ? CircularProgressIndicator()
                                                          : IconButton(
                                                              icon: Icon(
                                                                Icons.send,
                                                                color: Color(
                                                                  0xff32a2c0,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                _reportMentor();
                                                              },
                                                            ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Color(
                                                                    0xff32a2c0,
                                                                  ),
                                                                  width: 1,
                                                                ),
                                                          ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return 'Message is required.';
                                                      }
                                                      return null;
                                                    },
                                                    autocorrect: false,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    maxLines: 5,
                                                    minLines: 5,
                                                    controller:
                                                        reportMessageController,
                                                    enabled: !_isLoading,
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
                    hintText: widget.isPhone
                        ? 'Please contact by phone'
                        : 'Enter chat message',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Color(0xff32a2c0)),
                      onPressed: () {
                        _sendNewMessage();
                      },
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff32a2c0),
                        width: 1,
                      ),
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
                  enabled: !widget.isPhone,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(children: columnChildren);
  }
}
