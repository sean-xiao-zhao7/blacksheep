import "package:blacksheep/widgets/text/now_text.dart";
import "package:flutter/material.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

import "package:blacksheep/widgets/buttons/small_button_flexible.dart";
import "package:blacksheep/screens/chat/single_chat_screen.dart";
import "package:blacksheep/screens/login/login_screen.dart";
import "package:blacksheep/widgets/layouts/headers/genty_header.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";
import 'package:blacksheep/widgets/chat/chat_preview_widget.dart';
import "package:blacksheep/widgets/chat/chat_bubble_widget.dart";

/// Only for mentor account
/// Initially shows a list of both type 'chat' and 'phone'
/// Once _currentChatKey has been set, SingleChatScreen child widget takes over.
/// setCurrentChatKey is used to reset to the list of chats
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
  List<ChatPreviewWidget> _chatsPreviewList = [];
  final Map<int, List<ChatBubble>> _chatBubblesList = {};
  int _currentChatKey = -1;
  bool? isAccountActive;

  @override
  void initState() {
    super.initState();
    _getChats();
    _setupFCM();
    isAccountActive = widget.userData['active'];
  }

  Future<void> _setupFCM() async {
    /**
     * Set up Firebase messaging.
     * Get the FCM token on every mentor login.
     * Then insert this token into mentor's database entry.
     * To ensure FCM token is always up-to-date.
     */

    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    if (token != null) {
      _updateFCMMentor(token);
    }
  }

  Future<void> _updateFCMMentor(String token) async {
    try {
      final mentorRef = FirebaseDatabase.instance.ref().child(
        'users/${widget.userData['uid']}',
      );
      await mentorRef.update({'fcmToken': token});
    } catch (error) {
      // unable to update FCM to DB.
      // print(error);
    }
  }

  void setCurrentChatKey(int newKey) {
    setState(() {
      _currentChatKey = newKey;
    });

    if (newKey == -1) {
      _getChats();
    }
  }

  Future<void> _getChats() async {
    /**
     * Get all chats, then filter down to mentorUid equaling to this mentor's.     
     */

    String snackMessage = 'Could not get chat list.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("chats").get();
      if (!snapshot.exists) {
        return;
      }
      Map<dynamic, dynamic> allChats = snapshot.value as Map<dynamic, dynamic>;

      List<ChatPreviewWidget> newChatPreviewsList = [];
      int chatPreviewIndex = 0;
      for (final String key in allChats.keys) {
        var currentChat = allChats[key];
        currentChat['chatId'] = key;
        // print(currentChat);
        if (widget.userData['type'] == 'mentor' &&
            currentChat['mentorUid'] == widget.userData['uid']) {
          if (!currentChat['approved']) {
            continue;
          }

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
            ChatPreviewWidget currentChatPreview = ChatPreviewWidget(
              setChatListKey: setCurrentChatKey,
              chatPreviewIndex: chatPreviewIndex,
              chatInfo: currentChat,
            );
            newChatPreviewsList.add(currentChatPreview);
            _chatBubblesList[chatPreviewIndex] = _makeMessagesBubbles(
              currentChat,
            );
            chatPreviewIndex++;
          }
        }
      }
      setState(() {
        _chatsPreviewList = newChatPreviewsList;
        _isLoading = false;
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

  List<ChatBubble> _makeMessagesBubbles(Map<dynamic, dynamic> currentChat) {
    /**
     * Once the single chat has been received from Firebase,
     * Make a list of ChatMessageBubble for the SingleChatScreen to display.
     * Passes the result bubbles into the child widget.
     * This workflow could be improved in the future.
     * 
     * Also, this function could be outsourced and shared between all chat lists.
     */

    List<ChatBubble> tempBubbles = [];
    for (String key in currentChat['messages'].keys) {
      int timestamp;
      if (currentChat['messages'][key]['timestamp'] is String) {
        timestamp = int.parse(currentChat['messages'][key]['timestamp']);
      } else {
        timestamp = currentChat['messages'][key]['timestamp'];
      }

      ChatBubble currentBubble;
      currentBubble = ChatBubble(
        message: currentChat['messages'][key]['message'],
        isCurrentUser: currentChat['messages'][key]['mentee'] == false,
        timestamp: timestamp,
        userName: currentChat['messages'][key]['mentee']
            ? "${currentChat['menteeFirstName']} ${currentChat['menteeLastName']}"
            : "${currentChat['mentorFirstName']} ${currentChat['mentorLastName']}",
      );

      tempBubbles.add(currentBubble);
    }

    tempBubbles.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return tempBubbles;
  }

  Future<void> toggleAccountInactiveHandler() async {
    /**
     * Switch account to active/inactive.
     * Inactive mentor account will not be connected by MenteeChatList screen.    
     */
    try {
      bool newActiveVal = isAccountActive! ? false : true;

      DatabaseReference userRef = FirebaseDatabase.instance.ref(
        '/users/${widget.userData['uid']}',
      );
      await userRef.update({'active': newActiveVal});
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Set account to ${newActiveVal ? 'active' : 'inactive'}.',
            ),
          ),
        );
        Navigator.pop(context);
      }
      setState(() {
        isAccountActive = newActiveVal;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to set inactive. Please try later.')),
        );
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
                      child: SelectionArea(
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
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${widget.userData['email']!}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            _isLoading
                                ? CircularProgressIndicator()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SmallButtonFlexible(
                                        text: isAccountActive!
                                            ? 'Set Account Inactive'
                                            : 'Set Account Active',
                                        handler: toggleAccountInactiveHandler,
                                        backgroundColor: Colors.yellow,
                                        forgroundColor: Colors.black,
                                      ),
                                      SizedBox(height: 10),
                                      NowText(
                                        body: isAccountActive!
                                            ? 'Don\'t worry. This doesn\'t delete your account. It only temporarily disables it so you can return whenever you\'re available to serve. We ask that you mark your account as inactive if you are not available for matchups or messaging.'
                                            : 'Welcome back! If you\'re ready to connect with people in search of community, please click the button to Activate your account.',
                                      ),
                                    ],
                                  ),
                          ],
                        ),
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
                setCurrentChatKey(-1);
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
                      'Welcome to the BlackSheep App, connecting people with community!\n\nIt won\'t be long now before you receive your first connection.\n\nBe sure to reply promptly to messages, and check your email for meetup connections.\n\nFeel welcome to reach out to our support team if you have any questions.',
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
                chatBubbles: _chatBubblesList[_currentChatKey]!,
                chatId: _chatsPreviewList[_currentChatKey].chatInfo['chatId'],
                isMentor: true,
                mentorFirstName: _chatsPreviewList[_currentChatKey]
                    .chatInfo['mentorFirstName'],
                mentorLastName: _chatsPreviewList[_currentChatKey]
                    .chatInfo['mentorLastName'],
                mentorEmail: widget.userData['email'],
                menteeFirstName: _chatsPreviewList[_currentChatKey]
                    .chatInfo['menteeFirstName'],
                menteeLastName: _chatsPreviewList[_currentChatKey]
                    .chatInfo['menteeLastName'],
                menteePhone:
                    _chatsPreviewList[_currentChatKey].chatInfo['phone'],
                menteeAge: _chatsPreviewList[_currentChatKey].chatInfo['age'],
                menteeGender:
                    _chatsPreviewList[_currentChatKey].chatInfo['gender'],
                isPhone:
                    _chatsPreviewList[_currentChatKey].chatInfo['type'] ==
                    'phone',
                isDisabled:
                    _chatsPreviewList[_currentChatKey].chatInfo['disabled'],
                setChatListKey: () {},
                refreshChat: _getChats,
              )),
      ),
    );
  }
}
