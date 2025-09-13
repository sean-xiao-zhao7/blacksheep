import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import 'dart:math';
import 'package:video_player/video_player.dart';

import "package:sheepfold/screens/chat/single_chat.dart";
import "package:sheepfold/screens/login/login_screen.dart";
import "package:sheepfold/widgets/buttons/main_button.dart";
import "package:sheepfold/widgets/layouts/headers/genty_header.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class ChatList extends StatefulWidget {
  const ChatList(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<StatefulWidget> createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  bool _isLoading = true;
  bool _showInitialMessage = false;
  List matches = [];
  late VideoPlayerController _controller;
  final _menteeInitialMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMatches();
    _controller = VideoPlayerController.asset('assets/videos/video2.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  /// get all matches belonging to current mentor (only mentor)
  void _getMatches() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("users-matches").get();
      if (!snapshot.exists) {
        throw Error();
      }
      Map<dynamic, dynamic> allMatches =
          snapshot.value as Map<dynamic, dynamic>;

      List myMatches = [];
      for (final String key in allMatches.keys) {
        var currentMatch = allMatches[key];
        if (widget.userData['type'] == 'mentor' &&
            currentMatch['mentor'] == widget.userData['uid']) {
          currentMatch['matchId'] = key;
          myMatches.add(currentMatch);
        } else if (widget.userData['type'] == 'mentee' &&
            currentMatch['mentee'] == widget.userData['uid']) {
          currentMatch['matchId'] = key;
          myMatches.add(currentMatch);
        }
      }
      setState(() {
        matches = myMatches;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error getting matches.')),
        );
      }
    }
  }

  /// Make database connection between current user and a mentor (only mentee)
  void _connectToMentor(String type) async {
    setState(() {
      _isLoading = true;
    });
    String snackMessage = '';

    if (_menteeInitialMessageController.text.isEmpty ||
        _menteeInitialMessageController.text.length < 10) {
      snackMessage = 'Please enter a short message.';
    } else {
      try {
        final usersRef = FirebaseDatabase.instance.ref().child('users');
        final snapshot = await usersRef.get();

        if (snapshot.exists) {
          Map<dynamic, dynamic> allUsers =
              snapshot.value as Map<dynamic, dynamic>;

          // find closest mentor
          String closestUid = '';
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
                closestUid = key;
              }
            }
          }

          Map<String, dynamic> matchData = {
            'mentor': closestUid,
            'mentee': widget.userData['uid'],
            'type': type,
          };
          DatabaseReference matchesRef = FirebaseDatabase.instance.ref(
            "users-matches",
          );
          DatabaseReference newUserMatch = matchesRef.push();
          await newUserMatch.set(matchData);
          snackMessage = "We will notify you once a matchup becomes available!";

          // add initial mentee message as first message of a new chat thread
          DatabaseReference chatstRef = FirebaseDatabase.instance.ref("chats");
          DatabaseReference newChatRef = chatstRef.push();
          await newChatRef.set({'uid': widget.userData['uid']});
          newChatRef.child('messages').push().set({
            'mentee': true,
            'message': _menteeInitialMessageController.text,
          });

          // update current user with new match id and chat id
          usersRef.child(widget.userData['uid']).update({
            'matchId': newUserMatch.key,
            'chatId': newChatRef.key,
          });
        } else {
          snackMessage = 'Please check back later!';
        }

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        // print(error);
        setState(() {
          _isLoading = false;
        });
        snackMessage = 'Error, please try again later.';
      }
    }

    if (mounted) {
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
    final userType = widget.userData['type'];
    final menteeCount = 0;

    if (firstName != null) {
      setState(() {
        _isLoading = false;
      });
    }

    _controller.play();

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
        padding: userType == 'mentee' ? EdgeInsets.all(10) : EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child:
            userType ==
                'mentee' // user is mentee
            ? (_isLoading
                  ? Center(
                      heightFactor: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xff32a2c0),
                        strokeWidth: 10,
                        strokeAlign: 5,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : (matches.isEmpty
                        ? Column(
                            spacing: 10,
                            children: (_showInitialMessage
                                ? [
                                    Container(
                                      padding: EdgeInsets.all(20),
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
                                  ]
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
                                    _controller.value.isInitialized
                                        ? SizedBox(
                                            height: 360,
                                            child: VideoPlayer(_controller),
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
                        : SingleChat()))
            : (_isLoading // user is mentor
                  ? Center(
                      heightFactor: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xff32a2c0),
                        strokeWidth: 10,
                        strokeAlign: 5,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Column(
                      spacing: 20,
                      children: [
                        NowHeader('Welcome $firstName!', fontSize: 26),
                        menteeCount == 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff32a2c0).withAlpha(210),
                                ),
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(top: 150),
                                child: NowHeader(
                                  'We have no matches for you at the moment. We will notify you once a matchup becomes available.',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            : ListView(children: []),
                      ],
                    )),
      ),
    );
  }
}
