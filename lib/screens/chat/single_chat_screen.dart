import "package:blacksheep/widgets/text/now_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:url_launcher/url_launcher.dart';
import "package:firebase_database/firebase_database.dart";

import "package:blacksheep/services/email_service.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";
import "package:blacksheep/widgets/buttons/small_button_flexible.dart";
import "package:blacksheep/widgets/chat/chat_bubble_widget.dart";

/// A single chat between 2 people. Can be seen as mentor, mentee and admin.
/// Not a scaffold widget, just a child of the "chat list" parent widget.
/// Use "setChatListKey(-1)" callback to trigger parent to switch to list of chats view instead of single chat.
class SingleChat extends StatefulWidget {
  const SingleChat({
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
    this.menteeGender = '',
    this.isAdmin = false,
    this.isPhone = false,
    this.isApproved = false,
    this.isDisabled = false,
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
  final String menteeGender;
  final bool isAdmin;
  final bool isPhone;
  final bool isApproved;
  final bool isDisabled;
  final Function setChatListKey;
  final Function refreshChat;

  @override
  State<StatefulWidget> createState() {
    return _SingleChatState();
  }
}

class _SingleChatState extends State<SingleChat> {
  final TextEditingController _newMessageController = TextEditingController();
  final TextEditingController _reportMessageController =
      TextEditingController();
  final ScrollController _listViewController = ScrollController();

  // all mentors map for admin
  // key is Firebase UID
  Map<String, dynamic> _allMentors = {};

  bool _isLoading = false;
  String _newMentorUid = '';

  @override
  void initState() {
    super.initState();

    if (widget.isAdmin) {
      _getAllMentors();
    }
  }

  @override
  void dispose() {
    _newMessageController.dispose();
    _reportMessageController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  void displaySnackMessage(String snackMessage) {
    if (mounted && snackMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(snackMessage)));
    }
  }

  void resetChatList() {
    widget.setChatListKey(-1);
  }

  // get all mentors only for admin
  // Since admin could switch mentor. This is not needed if not switching.
  Future<void> _getAllMentors() async {
    String snackMessage = 'Server error while getting mentors for admin.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("users").get();
      if (!snapshot.exists) {
        return;
      }
      Map<dynamic, dynamic> allUsers = snapshot.value as Map<dynamic, dynamic>;

      Map<String, dynamic> allMentorsTemp = {};
      for (final String key in allUsers.keys) {
        var currentUser = allUsers[key];
        if (currentUser['type'] == 'mentor' &&
            (currentUser['active'] != null && currentUser['active'])) {
          allMentorsTemp[key] = {
            'firstName': currentUser['firstName'],
            'lastName': currentUser['lastName'],
            'email': currentUser['email'],
          };

          if (key == widget.mentorUid) {
            setState(() {
              _newMentorUid = key;
            });
          }
        }
      }
      setState(() {
        _allMentors = allMentorsTemp;
      });
    } catch (error) {
      displaySnackMessage(snackMessage);
    }
  }

  // send a single chat message for type chat
  // Only between mentor and mentee
  Future<void> _sendNewMessage() async {
    String snackMessage = '';
    try {
      DatabaseReference chatstRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}/messages",
      );
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      DatabaseReference newMessageRef = chatstRef.push();
      await newMessageRef.set({
        'mentee': !widget.isMentor,
        'message': _newMessageController.text,
        'timestamp': timestamp,
      });
      _newMessageController.clear();
      widget.refreshChat();
      _scrollDown();
    } catch (error) {
      snackMessage = 'Unable to send message, please try again later';
      displaySnackMessage(snackMessage);
    }
  }

  // after sending message in chat, scroll down to the bottom of the ListView
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
  void _reportMentor() {
    setState(() {
      _isLoading = true;
    });

    EmailService.sendReportEmail(
      widget.menteeFirstName,
      widget.mentorFirstName,
      _reportMessageController.text,
    );

    setState(() {
      _isLoading = false;
      _reportMessageController.clear();
    });

    Navigator.of(context).pop();
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

  // admin function for changing mentor/mentee connection
  Future<void> _changeMentor(String newMentorUid) async {
    String snackMessage = '';
    try {
      DatabaseReference chatsRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}",
      );
      var newMentor = _allMentors[newMentorUid];
      await chatsRef.update({
        'mentorFirstName': newMentor['firstName'],
        'mentorLastName': newMentor['lastName'],
        'mentorUid': newMentorUid,
      });

      // send email to mentor
      _sendMentorEmailPhone(chatsRef, newMentor['email']);

      // set chat list to overview mode
      snackMessage = 'Updated mentor successfully.';

      // close bottom sheet
      if (mounted) Navigator.pop(context);
    } catch (error) {
      snackMessage = 'Unable to change mentor, please try again later';
    }
    displaySnackMessage(snackMessage);
  }

  // admin function for approving new connection
  Future<void> _approveConnection() async {
    String snackMessage = '';
    try {
      DatabaseReference chatsRef = FirebaseDatabase.instance.ref(
        "chats/${widget.chatId}",
      );
      await chatsRef.update({'approved': true});

      // send email to mentor
      _sendMentorEmailPhone(chatsRef, _allMentors[widget.mentorUid]['email']);

      // set chat list to overview mode
      resetChatList();
      snackMessage = 'Approved connection!';
    } catch (error) {
      // print(error);
      snackMessage = 'Server error.';
    }
    displaySnackMessage(snackMessage);
  }

  // send an email to mentor when either new connection approved by admin
  // or mentee changed by admin
  Future<void> _sendMentorEmailPhone(
    DatabaseReference chatsRef,
    String email,
  ) async {
    if (widget.isPhone) {
      DataSnapshot result = await chatsRef.child('menteeUid').get();
      if (result.exists) {
        String menteeUid = result.value as String;
        DatabaseReference usersRef = FirebaseDatabase.instance.ref(
          'users/$menteeUid',
        );
        result = await usersRef.child('age').get();

        String age = result.value as String;
        result = await usersRef.child('phone').get();
        String phone = result.value as String;

        EmailService.sendNewMatchPhoneMentor(
          newMenteeName: "${widget.menteeFirstName} ${widget.menteeLastName}",
          phone: phone,
          age: age,
          mentorEmail: email,
        );
      }
    }
  }

  Future<void> toggleConnectionDisabledHandler() async {
    /**
     * Switch account to active/inactive.
     * Inactive mentor account will not be connected by MenteeChatList screen.    
     */
    try {
      DatabaseReference chatRef = FirebaseDatabase.instance.ref(
        '/chats/${widget.chatId}/disabled',
      );
      await chatRef.set(!widget.isDisabled);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${!widget.isDisabled ? 'Disabled' : 'Enabled'} connection.',
            ),
          ),
        );
        Navigator.pop(context);
        resetChatList();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to disable/enable account. Please try later.',
            ),
          ),
        );
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
              handler: _approveConnection,
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
                                  items: () {
                                    List<DropdownMenuItem<String>>
                                    dropdownItems = [];
                                    _allMentors.forEach((key, value) {
                                      dropdownItems.add(
                                        DropdownMenuItem(
                                          value: key,
                                          child: Text(
                                            '${value['firstName']} ${value['lastName']}',
                                          ),
                                        ),
                                      );
                                    });
                                    return dropdownItems;
                                  }(),
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
                          ? 'Connecting with ${widget.mentorFirstName} ${widget.mentorLastName}'
                          : '${widget.isAdmin ? '${widget.mentorFirstName} ${widget.mentorLastName} |' : ''} ${widget.menteeFirstName} ${widget.menteeLastName}',
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
                        if (widget.isPhone && !widget.isAdmin)
                          IconButton(
                            iconSize: 26,
                            icon: const Icon(Icons.phone),
                            onPressed: _callMentee,
                            padding: EdgeInsets.all(0),
                          ),
                        MenuAnchor(
                          menuChildren: <Widget>[
                            if (widget.isMentor && !widget.isAdmin)
                              MenuItemButton(
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
                                          child: SelectionArea(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${widget.menteeFirstName} ${widget.menteeLastName}',
                                                  style: TextStyle(
                                                    color: Color(0xff32a2c0),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                if (widget.menteeAge.isNotEmpty)
                                                  Text(
                                                    'Age: ${widget.menteeAge}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                if (widget
                                                    .menteeGender
                                                    .isNotEmpty)
                                                  Text(
                                                    'Gender: ${widget.menteeGender}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                if (widget.isPhone &&
                                                    widget
                                                        .menteePhone
                                                        .isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Phone: ${widget.menteePhone}',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          await Clipboard.setData(
                                                            ClipboardData(
                                                              text: widget
                                                                  .menteePhone,
                                                            ),
                                                          );
                                                          if (context.mounted) {
                                                            showDialog<String>(
                                                              context: context,
                                                              builder:
                                                                  (
                                                                    BuildContext
                                                                    context,
                                                                  ) => AlertDialog(
                                                                    title: const NowText(
                                                                      body:
                                                                          'Phone number copied to clipboard.',
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                          context,
                                                                          'OK',
                                                                        ),
                                                                        child: const Text(
                                                                          'OK',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            );
                                                          }
                                                        },
                                                        icon: const Icon(
                                                          Icons.copy,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                },
                                child: Text('About ${widget.menteeFirstName}'),
                              ),
                            if (!widget.isMentor && !widget.isAdmin)
                              MenuItemButton(
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
                                                        borderSide: BorderSide(
                                                          color: Color(
                                                            0xff32a2c0,
                                                          ),
                                                          width: 1,
                                                        ),
                                                      ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
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
                                                    _reportMessageController,
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
                            if (widget.isAdmin)
                              MenuItemButton(
                                trailingIcon: Icon(Icons.warning),
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
                                              _isLoading
                                                  ? CircularProgressIndicator()
                                                  : SmallButtonFlexible(
                                                      text: widget.isDisabled
                                                          ? 'Enable connection'
                                                          : 'Disable connection',
                                                      handler:
                                                          toggleConnectionDisabledHandler,
                                                      backgroundColor:
                                                          Colors.red,
                                                      forgroundColor:
                                                          Colors.white,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                },
                                child: Text(
                                  widget.isDisabled
                                      ? 'Enable connection'
                                      : 'Disable connection',
                                ),
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
                        child: widget.chatBubbles.isEmpty
                            ? Center(child: Text('No chat messages yet!'))
                            : ListView(
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
                    hintText: widget.isDisabled
                        ? 'Connection disabled'
                        : widget.isPhone
                        ? 'Connected via phone'
                        : 'Enter chat message',
                    suffixIcon: widget.isDisabled
                        ? IconButton(
                            icon: Icon(Icons.warning, color: Colors.red),
                            onPressed: () {},
                          )
                        : widget.isPhone
                        ? IconButton(
                            icon: Icon(Icons.phone, color: Color(0xff32a2c0)),
                            onPressed: () {},
                          )
                        : IconButton(
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
                  controller: _newMessageController,
                  enabled: (!widget.isPhone && !widget.isDisabled),
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
