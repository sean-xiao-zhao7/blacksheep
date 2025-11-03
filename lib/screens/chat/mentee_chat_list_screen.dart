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
import "package:blacksheep/services/email_service.dart";

/// The main chat screen for mentee after logging in.
///
/// Manages states regarding matched or not matched.
///
class MenteeChatListScreen extends StatefulWidget {
  const MenteeChatListScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<StatefulWidget> createState() {
    return _MenteeChatListScreen();
  }
}

class _MenteeChatListScreen extends State<MenteeChatListScreen> {
  bool _isLoading = true;
  bool _showInitialMessage = false;
  bool _waitingForConnection = false;
  bool _isPhoneConnectionMentee = false;
  List myChats = [];
  late VideoPlayerController _menteeConnectVideoController;
  late VideoPlayerController _menteeWaitVideoController;
  final _menteeInitialMessageController = TextEditingController();
  // var _token;

  @override
  void initState() {
    super.initState();
    _getChats();
    _menteeConnectVideoController =
        VideoPlayerController.asset('assets/videos/video2.mp4')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
    _menteeWaitVideoController =
        VideoPlayerController.asset('assets/videos/video3.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  /// get all matches belonging to current user
  void _getChats() async {
    if (widget.userData['chatId'] == null) {
      return;
    }

    String snackMessage = 'Server error while getting matches for user.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref
          .child("chats/${widget.userData['chatId']}")
          .get();
      if (!snapshot.exists) {
        // print('No matches/chats in database.');
        return;
      }
      Map<dynamic, dynamic> currentChat =
          snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        if (!currentChat['approved']) {
          _waitingForConnection = true;
          if (currentChat['type'] == 'phone') {
            _isPhoneConnectionMentee = true;
          }
        } else {
          myChats = [currentChat];
        }
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

  /// Make database connection between current user and a mentor (only mentee)
  void _connectToMentor(String type) async {
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
          // String closestMentorEmail = '';
          double closestDistance = 100000000;
          for (String key in allUsers.keys) {
            Map<dynamic, dynamic> currentUser = allUsers[key];
            if (currentUser['type'] == 'mentor') {
              double newDistance = calculateDistance(
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
                // closestMentorEmail = currentUser['email'];
              }
            }
          }

          // add initial mentee message as first message of a new chat thread
          DatabaseReference chatstRef = FirebaseDatabase.instance.ref("chats");
          DatabaseReference newChatRef = chatstRef.push();
          await newChatRef.set({
            'menteeUid': widget.userData['uid'],
            'mentorUid': closestMentorUid,
            'type': type,
            'menteeFirstName': widget.userData['firstName'],
            'menteeLastName': widget.userData['lastName'],
            'mentorFirstName': closestMentorFirstName,
            'mentorLastName': closestMentorLastName,
            'approved': false,
          });

          newChatRef.child('messages').push().set({
            'mentee': true,
            'message': type == 'chat'
                ? _menteeInitialMessageController.text
                : "New Matchup Available\n\n${widget.userData['firstName']} is in search of community.\n\nPlease contact:\n\nFirstname: ${widget.userData['firstName']}\nLastname: ${widget.userData['lastName']}\nPhone: ${widget.userData['phone']}\nAge: ${widget.userData['age']}\n\nPlease contact them within 48 hours of receiving this message.\n\nif you have any question, email: contact.us.blacksheep@gmail.com",
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });

          // update current user with new match id and chat id
          usersRef.child(widget.userData['uid']).update({
            'chatId': newChatRef.key,
          });

          // email mentor if type is phone
          if (type == 'phone') {
            EmailService.sendNewMatchPhoneMentor(
              newMenteeName:
                  "${widget.userData['firstName']} ${widget.userData['lastName']}",
              phone: widget.userData['phone'],
              age: widget.userData['age'],
              // mentorEmail: closestMentorEmail,
            );
          }

          // email admin about this new connection for approval
          EmailService.sendNewMatchEmailAdmin(
            newMenteeName:
                "${widget.userData['firstName']} ${widget.userData['lastName']}",
            newMentorName: "$closestMentorFirstName, $closestMentorLastName",
          );
        } else {
          snackMessage = 'Server error. Please check back later!';
        }

        setState(() {
          _isLoading = false;
          _showInitialMessage = true;
          _waitingForConnection = true;
        });
      } catch (error) {
        // print(error);
        setState(() {
          _isLoading = false;
        });
        snackMessage = 'Server error. Please check back later!';
      }
    }

    if (mounted && snackMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(snackMessage)));
    }
  }

  /// Calculate distance between two coordinates.
  double calculateDistance(lat1, lon1, lat2, lon2) {
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
    final firstName = widget.userData['firstName'];

    if (firstName != null) {
      setState(() {
        _isLoading = false;
      });
    }

    if (myChats.isEmpty) {
      if (_waitingForConnection) {
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
            // ListTile(
            //   title: const Text('Test email'),
            //   onTap: () {
            //     EmailService.sendNewMatchPhoneMentor();
            //   },
            // ),
          ],
        ),
      ),
      body: Container(
        padding: myChats.isEmpty
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
            : (myChats.isEmpty
                  ? Column(
                      spacing: 10,
                      children: (_showInitialMessage
                          ? (_waitingForConnection
                                ? [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xffa06181).withAlpha(230),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: NowHeader(
                                        _isPhoneConnectionMentee
                                            ? 'Someone will be in touch with you on the phone shortly!'
                                            : 'Someone will be in touch with you shortly!',
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 100),
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
                                        color: Color(0xffa06181).withAlpha(230),
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
                                          _showInitialMessage = false;
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
                                  'Find your place in your community!\nPlease select how you\'d prefer to connect:',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              _menteeConnectVideoController.value.isInitialized
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
                                    _showInitialMessage = true;
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
                    )
                  : SingleChat(
                      messages: myChats[0]['messages'],
                      chatId: myChats[0]['chatId'],
                      isMentor: false,
                      mentorFirstName: myChats[0]['mentorFirstName'],
                      setChatListKey: () {},
                    ))),
      ),
    );
  }
}
