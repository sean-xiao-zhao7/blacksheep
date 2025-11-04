import 'package:flutter/material.dart';

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

import "package:blacksheep/screens/login/login_screen.dart";
import "package:blacksheep/screens/chat/single_chat_screen.dart";

import "package:blacksheep/widgets/layouts/headers/genty_header.dart";
import "package:blacksheep/widgets/layouts/headers/now_header.dart";
import 'package:blacksheep/widgets/chat/chat_preview_widget.dart';
import "package:blacksheep/widgets/chat/chat_bubble_widget.dart";

/// Screen for managing all matches across entire system
///
class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({super.key, this.userData = const {}});
  final Map<String, dynamic> userData;

  @override
  State<StatefulWidget> createState() {
    return _AdminChatListScreenState();
  }
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  // bool _isLoading = true;
  List<ChatPreviewWidget> _chatsPreviewList = [];
  final Map<int, List<ChatBubble>> _chatBubblesList = {};
  int _currentChatKey = -1;

  @override
  void initState() {
    super.initState();
    getChats();
  }

  void setCurrentChatKey(int newKey) {
    setState(() {
      _currentChatKey = newKey;
    });
    getChats();
  }

  /// get all matches belonging to current user
  getChats() async {
    String snackMessage = 'Server error while getting matches for user.';
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child("chats").get();
      if (!snapshot.exists) {
        return;
      }
      Map<dynamic, dynamic> allChats = snapshot.value as Map<dynamic, dynamic>;

      List<ChatPreviewWidget> chatPreviewsListTemp = [];
      int chatPreviewIndex = 0;
      for (final String key in allChats.keys) {
        var currentChat = allChats[key];
        currentChat['chatId'] = key;
        ChatPreviewWidget currentChatPreview = ChatPreviewWidget(
          setChatListKey: setCurrentChatKey,
          chatPreviewIndex: chatPreviewIndex,
          chatInfo: currentChat,
          showBothNames: true,
        );
        chatPreviewsListTemp.add(currentChatPreview);
        _chatBubblesList[_currentChatKey] = _makeMessagesBubbles(currentChat);
        chatPreviewIndex++;
      }
      setState(() {
        _chatsPreviewList = chatPreviewsListTemp;
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

  _makeMessagesBubbles(Map<dynamic, dynamic> currentChat) {
    List<ChatBubble> tempBubbles = [];
    Map<dynamic, dynamic> chat = currentChat['messages'];
    for (String key in chat['messages'].keys) {
      int timestamp;
      if (chat['messages'][key]['timestamp'] is String) {
        timestamp = int.parse(chat['messages'][key]['timestamp']);
      } else {
        timestamp = chat['messages'][key]['timestamp'];
      }

      ChatBubble currentBubble;

      currentBubble = ChatBubble(
        message: chat['messages'][key]['message'],
        isCurrentUser: chat['messages'][key]['mentee'] == true,
        timestamp: timestamp,
        userName: chat['messages'][key]['mentee']
            ? "${chat['menteeFirstName']} ${chat['menteeLastName']}"
            : "${chat['mentorFirstName']} ${chat['mentorLastName']}",
      );

      tempBubbles.add(currentBubble);
    }

    tempBubbles.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return tempBubbles;
  }

  @override
  Widget build(BuildContext context) {
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
                            'BlackSheep Administrator',
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
              title: const Text('View All Connections'),
              onTap: () {
                setCurrentChatKey(-1);
                Navigator.pop(context);
              },
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
      body: RefreshIndicator(
        onRefresh: () {
          return getChats();
        },
        child: Container(
          padding: _chatsPreviewList.isEmpty
              ? EdgeInsets.all(20)
              : EdgeInsets.only(top: 10, right: 6, left: 6, bottom: 30),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/blacksheep_background_full.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: _currentChatKey == -1
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      NowHeader('Admin - All connections', fontSize: 18),
                      SizedBox(height: 15),
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
                  mentorUid:
                      _chatsPreviewList[_currentChatKey].chatInfo['mentorUid'],
                  menteeFirstName: _chatsPreviewList[_currentChatKey]
                      .chatInfo['menteeFirstName'],
                  menteeLastName: _chatsPreviewList[_currentChatKey]
                      .chatInfo['menteeLastName'],
                  isAdmin: true,
                  isApproved:
                      _chatsPreviewList[_currentChatKey].chatInfo['approved'],
                  setChatListKey: setCurrentChatKey,
                  refreshChat: getChats(),
                ),
        ),
      ),
    );
  }
}
