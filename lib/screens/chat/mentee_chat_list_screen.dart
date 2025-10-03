import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_email_sender/flutter_email_sender.dart';

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

import 'package:video_player/video_player.dart';

import "package:sheepfold/screens/chat/single_chat_screen.dart";
import "package:sheepfold/screens/login/login_screen.dart";
import "package:sheepfold/widgets/buttons/main_button.dart";
import "package:sheepfold/widgets/layouts/headers/genty_header.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

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
  List myChats = [];
  late VideoPlayerController _menteeConnectVideoController;
  late VideoPlayerController _menteeWaitVideoController;
  final _menteeInitialMessageController = TextEditingController();

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
    String snackMessage = 'Server error while getting matches for user.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("chats").get();
      if (!snapshot.exists) {
        // print('No matches/chats in database.');
        return;
      }
      Map<dynamic, dynamic> allChats = snapshot.value as Map<dynamic, dynamic>;

      List tempChats = [];
      for (final String key in allChats.keys) {
        var currentChat = allChats[key];
        currentChat['chatId'] = key;
        if (widget.userData['type'] == 'mentor' &&
            currentChat['mentorUid'] == widget.userData['uid']) {
          currentChat['isMentor'] = true;
          tempChats.add(currentChat);
        } else if (widget.userData['type'] == 'mentee' &&
            currentChat['menteeUid'] == widget.userData['uid']) {
          currentChat['isMentor'] = false;
          tempChats.add(currentChat);
          break;
        }
      }
      setState(() {
        myChats = tempChats;
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
            'menteeLastName': widget.userData['LastName'],
            'mentorFirstName': closestMentorFirstName,
            'mentorLastName': closestMentorLastName,
          });

          newChatRef.child('messages').push().set({
            'mentee': true,
            'message': type == 'chat'
                ? _menteeInitialMessageController.text
                : "${widget.userData['firstName']} is in search of community.\n\nPlease contact:\nFirstname: ${widget.userData['firstName']}\nLastname:${widget.userData['lastName']}\nPhone: ${widget.userData['phone']}\nAge: ${widget.userData['age']}\n\nPlease contact them within 48 hours of receiving this message.\nif you have any question, email: contact.us.blacksheep@gmail.com",
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });

          // update current user with new match id and chat id
          usersRef.child(widget.userData['uid']).update({
            'chatId': newChatRef.key,
          });
        } else {
          snackMessage = 'Server error. Please check back later!';
        }

        // send email and push note

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

  sendEmail() async {
    final Email email = Email(
      body: "Test",
      subject: "Test",
      recipients: ["john316rocks@gmail.com"],
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
      _menteeConnectVideoController.play();
    }
    if (_waitingForConnection) {
      _menteeWaitVideoController.play();
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
                            'Name: ${widget.userData['firstName']!} ${widget.userData['lastName']!}',
                            style: TextStyle(
                              color: Color(0xff32a2c0),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Email: ${widget.userData['email']!}',
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
              title: const Text('Logout'),
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
                                        'Someone will be in touch with you shortly!',
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
                    ))),
      ),
    );
  }
}
