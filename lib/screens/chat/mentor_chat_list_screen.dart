import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

import "package:blacksheep/screens/chat/single_chat_screen.dart";
import "package:blacksheep/screens/login/login_screen.dart";
import "package:blacksheep/widgets/layouts/headers/genty_header.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";
import 'package:blacksheep/widgets/chat/mentor_chat_preview_widget.dart';

/// The main chat screen for mentor after logging in.
///
/// Shows list of chats
///
class MentorChatListScreen extends StatefulWidget {
  const MentorChatListScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<StatefulWidget> createState() {
    return _MentorChatListScreen();
  }
}

class _MentorChatListScreen extends State<MentorChatListScreen> {
  bool _isLoading = true;
  List<MentorChatPreviewWidget> _chatsPreviewList = [];
  int _currentChatKey = -1;

  @override
  void initState() {
    super.initState();
    _getChats();
    _setupFCM();
  }

  void _setupFCM() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    if (token != null) {
      updateFCMMentor(token);
    }
  }

  void setCurrentChatKey(int newKey) {
    setState(() {
      _currentChatKey = newKey;
    });
  }

  // on every mentor login we add new FCM token (if any) to database
  void updateFCMMentor(String token) async {
    try {
      final mentorRef = FirebaseDatabase.instance.ref().child(
        'users/${widget.userData['uid']}',
      );
      await mentorRef.update({'fcmToken': token});
    } catch (error) {
      // unable to update FCM to DB.
    }
  }

  /// get all matches belonging to current user
  void _getChats() async {
    String snackMessage = 'Server error while getting matches for user.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("chats").get();
      if (!snapshot.exists) {
        return;
      }
      Map<dynamic, dynamic> allChats = snapshot.value as Map<dynamic, dynamic>;

      List<MentorChatPreviewWidget> newChatPreviewsList = [];
      int chatPreviewIndex = 0;
      for (final String key in allChats.keys) {
        var currentChat = allChats[key];
        if (!currentChat['approved']) {
          continue;
        }

        currentChat['chatId'] = key;
        if (widget.userData['type'] == 'mentor' &&
            currentChat['mentorUid'] == widget.userData['uid']) {
          currentChat['isMentor'] = true;

          // find user info from users collection
          DataSnapshot userSnapshot = await ref
              .child("users/${currentChat['menteeUid']}")
              .get();
          if (!userSnapshot.exists) {
            // user doesn't exist
            continue;
          } else {
            Map<dynamic, dynamic> menteeInfo =
                userSnapshot.value as Map<dynamic, dynamic>;

            currentChat['menteeLastname'] = menteeInfo['lastName'];
            currentChat['age'] = menteeInfo['age'];
            currentChat['phone'] = menteeInfo['phone'];
            currentChat['gender'] = menteeInfo['gender'];
            MentorChatPreviewWidget currentChatPreview =
                MentorChatPreviewWidget(
                  setChatListKey: setCurrentChatKey,
                  chatPreviewIndex: chatPreviewIndex,
                  chatInfo: currentChat,
                );
            newChatPreviewsList.add(currentChatPreview);
            chatPreviewIndex++;
          }
        }
      }
      setState(() {
        _chatsPreviewList = newChatPreviewsList;
      });
    } catch (error) {
      // print(error);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(snackMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.userData['firstName'];

    if (firstName != null) {
      setState(() {
        _isLoading = false;
      });
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
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          // Text(
                          //   'Type: ${widget.userData['type']!}',
                          //   style: TextStyle(
                          //     color: Color(0xff32a2c0),
                          //     fontSize: 20,
                          //   ),
                          // ),
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
              title: const Text('View All Connections'),
              onTap: () {
                setState(() {
                  _currentChatKey = -1;
                });
                Navigator.pop(context);
              },
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
        padding: _chatsPreviewList.isEmpty
            ? EdgeInsets.all(20)
            : EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child:
            (_isLoading // user is mentor
            ? Center(
                heightFactor: 20,
                child: CircularProgressIndicator(
                  color: Color(0xff32a2c0),
                  strokeWidth: 10,
                  strokeAlign: 5,
                  strokeCap: StrokeCap.round,
                ),
              )
            : _chatsPreviewList.isEmpty
            ? Column(
                spacing: 20,
                children: [
                  NowHeader('Welcome $firstName!', fontSize: 26),
                  Container(
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
                  ),
                ],
              )
            : _currentChatKey == -1
            ? Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    NowHeader('People you are connected with', fontSize: 20),
                    SizedBox(height: 10),
                    ..._chatsPreviewList,
                  ],
                ),
              )
            : SingleChat(
                messages:
                    _chatsPreviewList[_currentChatKey].chatInfo['messages'],
                chatId: _chatsPreviewList[_currentChatKey].chatInfo['chatId'],
                isMentor: true,
                mentorFirstName: _chatsPreviewList[_currentChatKey]
                    .chatInfo['mentorFirstName'],
                menteeFirstName: _chatsPreviewList[_currentChatKey]
                    .chatInfo['menteeFirstName'],
                isPhone:
                    _chatsPreviewList[_currentChatKey].chatInfo['type'] ==
                    'phone',
              )),
      ),
    );
  }
}
