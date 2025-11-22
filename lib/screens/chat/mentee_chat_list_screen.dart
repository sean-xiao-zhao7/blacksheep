import 'dart:math';
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import 'package:video_player/video_player.dart';

import "package:blacksheep/screens/chat/single_chat_screen.dart";
import "package:blacksheep/screens/login/login_screen.dart";
import "package:blacksheep/widgets/buttons/main_button.dart";
import "package:blacksheep/widgets/layouts/headers/genty_header.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";
import "package:blacksheep/widgets/chat/chat_bubble_widget.dart";
import "package:blacksheep/services/email_service.dart";
import "package:blacksheep/models/chat.dart";
import "package:blacksheep/widgets/buttons/small_button_flexible.dart";

final _firebaseAuth = FirebaseAuth.instance;

/// Only for mentee account
/// Only contains 1 chat for both type 'chat' and 'phone'
class MenteeChatListScreen extends StatefulWidget {
  const MenteeChatListScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<StatefulWidget> createState() {
    return _MenteeChatListScreen();
  }
}

class _MenteeChatListScreen extends State<MenteeChatListScreen> {
  // single chat data
  Chat? _myChat;
  List<ChatBubble> _chatBubbles = [];
  final _menteeInitialMessageController = TextEditingController();

  // videos for waiting for connection only
  late VideoPlayerController _menteeConnectVideoController;
  late VideoPlayerController _menteeWaitVideoController;

  bool _isLoading = true;
  bool _showNewMenteeQuestions = false;
  bool _waitingForMentor = false;

  @override
  void initState() {
    super.initState();

    // get single chat data, only if chatId from login is not null.
    // _myChat controls whether to display chat or waiting for connection message
    if (widget.userData['chatId'] != '') _getChat();

    _menteeConnectVideoController =
        VideoPlayerController.asset('assets/videos/video2.mp4')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized,
            // even before the play button has been pressed.
            setState(() {});
          });
    _menteeWaitVideoController =
        VideoPlayerController.asset('assets/videos/video3.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _menteeConnectVideoController.dispose();
    _menteeWaitVideoController.dispose();
    _menteeInitialMessageController.dispose();
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

  Future<void> _getChat() async {
    // Only for mentee, get the single chat corresponding to the chatId passed in.
    // In the future we might allow more than 1 chat for a mentee.

    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref
          .child("chats/${widget.userData['chatId']}")
          .get();
      if (!snapshot.exists) {
        // print('No matches/chats in database.');
        return;
      }
      Map<dynamic, dynamic> currentChatData =
          snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        _myChat = Chat(
          id: widget.userData['chatId'],
          approved: currentChatData['approved'],
          menteeFirstName: currentChatData['menteeFirstName'],
          menteeLastName: currentChatData['menteeLastName'],
          menteeUid: currentChatData['menteeUid'],
          mentorFirstName: currentChatData['mentorFirstName'],
          mentorLastName: currentChatData['mentorLastName'],
          mentorUid: currentChatData['mentorUid'],
          messages: currentChatData['messages'],
          type: currentChatData['type'],
          disabled: currentChatData['disabled'],
        );

        if (!currentChatData['approved']) {
          _waitingForMentor = true;
          _showNewMenteeQuestions = true;
        }
        if (currentChatData['type'] == 'phone') {
          _showNewMenteeQuestions = true;
          _waitingForMentor = true;
        }
      });

      if (currentChatData['approved'] && !_myChat!.isPhone) {
        _makeMessagesBubbles();
      }
    } on FirebaseException catch (error) {
      displaySnackMessage(error.code);
    }
  }

  void _makeMessagesBubbles() {
    // Once the single chat has been received from Firebase,
    // Make a list of ChatMessageBubble for the SingleChatScreen to display.
    // Passes the result bubbles into the child widget.
    // This workflow could be improved in the future.
    //
    // Also, this function could be outsourced and shared between all chat lists.

    List<ChatBubble> tempBubbles = [];
    Map<dynamic, dynamic> messages = _myChat!.messages;
    for (String key in messages.keys) {
      int timestamp;
      if (messages[key]['timestamp'] is String) {
        timestamp = int.parse(messages[key]['timestamp']);
      } else {
        timestamp = messages[key]['timestamp'];
      }

      ChatBubble currentBubble;

      currentBubble = ChatBubble(
        message: messages[key]['message'],
        isCurrentUser: messages[key]['mentee'] == true,
        timestamp: timestamp,
        userName: messages[key]['mentee']
            ? "${_myChat!.menteeFirstName} ${_myChat!.menteeLastName}"
            : "${_myChat!.mentorFirstName} ${_myChat!.mentorLastName}",
      );

      tempBubbles.add(currentBubble);
    }
    setState(() {
      tempBubbles.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      _chatBubbles = tempBubbles;
      _isLoading = false;
    });
  }

  Future<void> _connectToMentor(String type) async {
    // Called initially when mentee clicks on "Connect By Phone/Chat"
    // Finds the geographically nearest mentor, then adds a new "chat" document in Firebase.
    // Currently does not balance a mentor's already connected mentees against other mentors.
    // This connection requires admin approval, until then, nothing changes in the UI.

    setState(() {
      _isLoading = true;
    });
    String snackMessage = '';

    if (type == 'chat' &&
        (_menteeInitialMessageController.text.isEmpty ||
            _menteeInitialMessageController.text.length < 10)) {
      snackMessage = 'Please enter a message longer than 10 characters.';
    } else {
      try {
        final usersRef = FirebaseDatabase.instance.ref().child('users');
        final snapshot = await usersRef.get();

        if (snapshot.exists) {
          Map<dynamic, dynamic> allUsers =
              snapshot.value as Map<dynamic, dynamic>;

          // find closest mentor
          String closestMentorUid = '';
          String closestMentorFirstName = '';
          String closestMentorLastName = '';
          double closestDistance = 100000000;
          for (String key in allUsers.keys) {
            Map<dynamic, dynamic> currentUser = allUsers[key];
            if (currentUser['type'] == 'mentor' &&
                (currentUser['active'] != null && currentUser['active'])) {
              double newDistance = _calculateDistance(
                currentUser['latitude'],
                currentUser['longitude'],
                widget.userData['latitude'],
                widget.userData['longitude'],
              );
              if (newDistance < closestDistance) {
                closestDistance = newDistance;
                closestMentorUid = key;
                closestMentorFirstName = currentUser['firstName'];
                closestMentorLastName = currentUser['lastName'];
              }
            }
          }

          // add initial mentee message as first message of a new chat thread
          DatabaseReference chatstRef = FirebaseDatabase.instance.ref("chats");
          DatabaseReference newChatRef = chatstRef.push();
          await newChatRef.set({
            'approved': false,
            'menteeFirstName': widget.userData['firstName'],
            'menteeLastName': widget.userData['lastName'],
            'menteeUid': widget.userData['uid'],
            'mentorFirstName': closestMentorFirstName,
            'mentorLastName': closestMentorLastName,
            'mentorUid': closestMentorUid,
            'type': type,
            'disabled': false,
          });

          DatabaseReference firstMessageRef = newChatRef
              .child('messages')
              .push();
          Map<String, dynamic> newMessageBody = {
            'mentee': true,
            'message': type == 'chat'
                ? _menteeInitialMessageController.text
                : "New Matchup Available\n\n${widget.userData['firstName']} is in search of community.\n\nPlease contact:\n\nFirstname: ${widget.userData['firstName']}\nLastname: ${widget.userData['lastName']}\nPhone: ${widget.userData['phone']}\nAge: ${widget.userData['age']}\n\nPlease contact them within 48 hours of receiving this message.\n\nif you have any question, email: contact.us.blacksheep@gmail.com",
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };
          firstMessageRef.set(newMessageBody);

          // update current user with new match id and chat id
          usersRef.child(widget.userData['uid']).update({
            'chatId': newChatRef.key,
          });

          // email admin about this new connection for approval
          EmailService.sendNewMatchEmailAdmin(
            newMenteeName:
                "${widget.userData['firstName']} ${widget.userData['lastName']}",
            newMentorName: "$closestMentorFirstName, $closestMentorLastName",
          );

          setState(() {
            _myChat = Chat(
              id: newChatRef.key!,
              approved: false,
              menteeFirstName: widget.userData['firstName'],
              menteeLastName: widget.userData['lastName'],
              menteeUid: widget.userData['uid'],
              mentorFirstName: closestMentorFirstName,
              mentorLastName: closestMentorLastName,
              mentorUid: closestMentorUid,
              type: type,
              messages: {
                firstMessageRef.key: {newMessageBody},
              },
              disabled: false,
            );

            _waitingForMentor = true;
            if (type == 'phone') {
              _showNewMenteeQuestions = true;
            }
          });
        } else {
          snackMessage = 'Server error. Please check back later!';
        }

        setState(() {
          _isLoading = false;
          _showNewMenteeQuestions = true;
          _waitingForMentor = true;
        });
      } on FirebaseException catch (error) {
        setState(() {
          _isLoading = false;
        });
        snackMessage = error.code;
      }
    }

    displaySnackMessage(snackMessage);
  }

  Future<void> deleteAccountHandler() async {
    // delete this user from firebase auth and firebase realtime database
    // mentees can choose to remove themselves. A mentor cannot.

    try {
      final userRef = FirebaseDatabase.instance.ref(
        'users/${widget.userData['uid']}',
      );
      await userRef.remove();

      if (widget.userData['chatId'] != '') {
        final chatRef = FirebaseDatabase.instance.ref(
          'chats/${widget.userData['chatId']}',
        );
        await chatRef.remove();
      }

      await _firebaseAuth.currentUser!.delete();

      if (mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
      }
    } on FirebaseException catch (error) {
      displaySnackMessage(error.code);
    }
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    // Calc distance between two (lat, long) coordinates.

    var p =
        0.017453292519943295; //conversion factor from radians to decimal degrees, exactly math.pi/180
    var c = cos;
    var a =
        0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var radiusOfEarth = 6371;
    return radiusOfEarth * 2 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userData['chatId'] != null) {
      setState(() {
        _isLoading = false;
      });
    }

    if ((_myChat == null || !_myChat!.approved) || _myChat!.isPhone) {
      if (_waitingForMentor) {
        _menteeWaitVideoController.play();
      } else {
        _menteeConnectVideoController.play();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: GentyHeader('BlackSheep', fontSize: 34),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff32a2c0),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
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
                            'Your info',
                            style: TextStyle(
                              color: Color.fromARGB(255, 43, 141, 168),
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${widget.userData['firstName']!} ${widget.userData['lastName']!}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 43, 141, 168),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${widget.userData['email']!}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 43, 141, 168),
                              fontSize: 20,
                            ),
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : SmallButtonFlexible(
                                  text: 'Delete Account',
                                  handler: deleteAccountHandler,
                                  backgroundColor: Colors.red,
                                  forgroundColor: Colors.white,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.person, color: Colors.white),
          ),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/blacksheep_background_full.png",
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: GentyHeader('BlackSheep', fontSize: 40),
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: _myChat == null || _myChat!.isPhone
            ? EdgeInsets.all(20)
            : EdgeInsets.only(top: 10, right: 6, left: 6, bottom: 30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: (_isLoading
            ? Center(
                heightFactor: 20,
                child: CircularProgressIndicator(
                  color: Color(0xff32a2c0),
                  strokeWidth: 10,
                  strokeAlign: 5,
                  strokeCap: StrokeCap.round,
                ),
              )
            : ((_myChat == null || !_myChat!.approved) || _myChat!.isPhone
                  ? ListView(
                      children: [
                        Column(
                          spacing: 10,
                          children: (_showNewMenteeQuestions
                              ? (_waitingForMentor
                                    ? [
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: NowHeader(
                                            'We\'ve sent your contact details to one of our community leaders. Someone will be in touch with your shortly.',
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 80),
                                        _menteeWaitVideoController
                                                .value
                                                .isInitialized
                                            ? SizedBox(
                                                height: 400,
                                                child: VideoPlayer(
                                                  _menteeWaitVideoController,
                                                ),
                                              )
                                            : CircularProgressIndicator(),
                                      ]
                                    : [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xffa06181,
                                            ).withAlpha(230),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: NowHeader(
                                            'In a few words, tell us what you\'re looking for?',
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'Enter initial message',
                                            prefixIcon: Icon(
                                              Icons.message,
                                              color: Color(0xff32a2c0),
                                            ),
                                            counterStyle: TextStyle(
                                              color: Colors.black,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          autocorrect: false,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          maxLines: 5,
                                          minLines: 5,
                                          maxLength: 2000,
                                          controller:
                                              _menteeInitialMessageController,
                                        ),
                                        MainButton(
                                          'Finish',
                                          () => {_connectToMentor('chat')},
                                          size: 400,
                                        ),
                                        MainButton(
                                          'Cancel',
                                          () => {
                                            setState(() {
                                              _showNewMenteeQuestions = false;
                                            }),
                                          },
                                          size: 400,
                                        ),
                                      ])
                              : [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Color(0xffa06181).withAlpha(230),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: NowHeader(
                                      'Find your place in your community!\nLock in your preference on how you\'d like to connect with someone.\n\nButton 1: In App Texting.\n\nButton 2: Contact Me By Phone',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  _menteeConnectVideoController
                                          .value
                                          .isInitialized
                                      ? SizedBox(
                                          height: 360,
                                          child: VideoPlayer(
                                            _menteeConnectVideoController,
                                          ),
                                        )
                                      : CircularProgressIndicator(),
                                  MainButton(
                                    'In app text',
                                    () => {
                                      setState(() {
                                        _showNewMenteeQuestions = true;
                                      }),
                                    },
                                    size: 400,
                                  ),
                                  MainButton(
                                    'Phone',
                                    () => {_connectToMentor('phone')},
                                    size: 400,
                                  ),
                                ]),
                        ),
                      ],
                    )
                  : SingleChat(
                      chatBubbles: _chatBubbles,
                      chatId: _myChat!.id,
                      isMentor: false,
                      isDisabled: _myChat!.disabled,
                      mentorFirstName: _myChat!.mentorFirstName,
                      setChatListKey: () {},
                      refreshChat: _getChat,
                    ))),
      ),
    );
  }
}
