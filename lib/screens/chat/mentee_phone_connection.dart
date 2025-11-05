import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

import "package:firebase_database/firebase_database.dart";

import "package:blacksheep/services/email_service.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";
import "package:blacksheep/widgets/buttons/small_button_flexible.dart";
import "package:blacksheep/widgets/chat/chat_bubble_widget.dart";

/// A single chat between 2 parties.
class MenteePhoneConnection extends StatefulWidget {
  const MenteePhoneConnection({
    super.key,
    this.chatId = '',
    this.chatBubbles = const [],
    this.isMentor = false,
    this.mentorFirstName = '',
    this.mentorLastName = '',
    this.mentorUid = '',
    this.mentorEmail = '',
    this.menteeFirstName = '',
    this.menteeLastName = '',
    this.menteePhone = '',
    this.menteeAge = '',
    this.isAdmin = false,
    this.isPhone = false,
    this.isApproved = false,
    required this.setChatListKey,
    required this.refreshChat,
  });
  final String chatId;
  final List<ChatBubble> chatBubbles;
  final bool isMentor;
  final String mentorFirstName;
  final String mentorLastName;
  final String mentorUid;
  final String mentorEmail;
  final String menteeFirstName;
  final String menteeLastName;
  final String menteePhone;
  final String menteeAge;
  final bool isAdmin;
  final bool isPhone;
  final bool isApproved;
  final Function setChatListKey;
  final Function refreshChat;

  @override
  State<StatefulWidget> createState() {
    return _MenteePhoneConnectionState();
  }
}

class _MenteePhoneConnectionState extends State<MenteePhoneConnection> {
  bool _isLoading = false;
  TextEditingController newMessageController = TextEditingController();
  TextEditingController reportMessageController = TextEditingController();
  final ScrollController _listViewController = ScrollController();
  List<dynamic> _mentorsSelectionList = [];
  String _newMentorUid = '';

  @override
  void initState() {
    super.initState();
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

  _sendNewMessage() async {
    String snackMessage = '';
    try {
      DatabaseReference chatstRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}/messages",
      );
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      DatabaseReference newMessageRef = chatstRef.push();
      await newMessageRef.set({
        'mentee': !widget.isMentor,
        'message': newMessageController.text,
        'timestamp': timestamp,
      });
      widget.refreshChat();
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

  // admin function for changing mentor/mentee connection
  _changeMentor(String newMentorUid) async {
    String snackMessage = '';
    try {
      DatabaseReference chatsRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}",
      );
      var newMentor = _mentorsSelectionList.firstWhere(
        (mentor) => mentor['uid'] == newMentorUid,
      );
      await chatsRef.update({
        'mentorFirstName': newMentor['firstName'],
        'mentorLastName': newMentor['lastName'],
        'mentorUid': newMentorUid,
      });
      sendMentorEmailPhone(chatsRef);
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

  // go to bottom of chat list
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

  // mentee function for reporting bad mentor
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

  // admin function for approving new connection
  void approveConnection() async {
    String resultMessage = '';
    try {
      DatabaseReference chatsRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}",
      );
      await chatsRef.update({'approved': true});
      sendMentorEmailPhone(chatsRef);
      resultMessage = 'Approved connection!';
      // set chat list to overview mode
      widget.setChatListKey(-1);
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

  sendMentorEmailPhone(DatabaseReference chatsRef) async {
    // email mentor if type is phone
    if (widget.isPhone) {
      // find out mentee's age/phone
      DataSnapshot result = await chatsRef.child('menteeUid').get();
      if (result.exists) {
        int menteeUid = result.value as int;
        DatabaseReference usersRef = FirebaseDatabase.instance.ref(
          'users/$menteeUid',
        );
        result = await usersRef.child('age').get();
        int age = result.value as int;
        result = await usersRef.child('phone').get();
        int phone = result.value as int;

        EmailService.sendNewMatchPhoneMentor(
          newMenteeName: "${widget.menteeFirstName} ${widget.menteeLastName}",
          phone: phone,
          age: age,
          mentorEmail: widget.mentorEmail,
        );
      }
    }
  }

  // mentor function for launching phone app with mentee's number
  Future<void> _callMentee() async {
    bool result = await canLaunchUrl(Uri.parse('tel:${widget.menteePhone}'));
    if (result) {
      if (!await launchUrl(Uri.parse('tel:${widget.menteePhone}'))) {
        throw Exception('Could not launch phone.');
      }
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
                          : '${widget.isAdmin ? '${widget.mentorFirstName} ${widget.mentorLastName}) |' : 'Chatting with'} ${widget.menteeFirstName} ${widget.menteeLastName}',
                      fontSize: 12,
                      color: Color(0xff32a2c0),
                    ),
                    Row(
                      children: [
                        IconButton(
                          iconSize: 26,
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            widget.refreshChat();
                          },
                          padding: EdgeInsets.all(0),
                        ),
                        if (widget.isMentor)
                          IconButton(
                            iconSize: 26,
                            icon: const Icon(Icons.phone),
                            onPressed: _callMentee,
                            padding: EdgeInsets.all(0),
                          ),
                        MenuAnchor(
                          menuChildren: <Widget>[
                            widget.isMentor
                                ? MenuItemButton(
                                    trailingIcon: Icon(Icons.person),
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
                                                    '${widget.menteeFirstName} ${widget.menteeLastName}',
                                                    style: TextStyle(
                                                      color: Color(0xff32a2c0),
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Age: ${widget.menteeAge}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Phone: ${widget.menteePhone}',
                                                    style: TextStyle(
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
                                    child: Text(
                                      'About ${widget.menteeFirstName}',
                                    ),
                                  )
                                : MenuItemButton(
                                    trailingIcon: Icon(Icons.report_problem),
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
                          children: widget.chatBubbles,
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
