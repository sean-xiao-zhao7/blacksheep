import 'package:flutter/material.dart';

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

import "package:sheepfold/screens/login/login_screen.dart";
import "package:sheepfold/screens/chat/single_chat_screen.dart";

import 'package:sheepfold/widgets/chat/mentor_chat_preview_widget.dart';
import "package:sheepfold/widgets/layouts/headers/genty_header.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

/// Screen for managing all matches across entire system
///
class AdminMatchesListScreen extends StatefulWidget {
  const AdminMatchesListScreen({super.key, this.userData = const {}});
  final Map<String, dynamic> userData;

  @override
  State<StatefulWidget> createState() {
    return _AdminMatchesListScreenState();
  }
}

class _AdminMatchesListScreenState extends State<AdminMatchesListScreen> {
  List<MentorChatPreviewWidget> _chatsPreviewList = [];
  int _currentChatKey = -1;

  @override
  void initState() {
    super.initState();
    _getChats();
  }

  void setCurrentChatKey(int newKey) {
    setState(() {
      _currentChatKey = newKey;
    });
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
        currentChat['chatId'] = key;
        MentorChatPreviewWidget currentChatPreview = MentorChatPreviewWidget(
          setChatListKey: () => setCurrentChatKey(chatPreviewIndex),
          chatInfo: currentChat,
          showBothNames: true,
        );
        newChatPreviewsList.add(currentChatPreview);
      }
      setState(() {
        _chatsPreviewList = newChatPreviewsList;
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
                            'Blacksheep Administrator',
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
              title: const Text('All Matches'),
              onTap: () {
                setState(() {
                  _currentChatKey = -1;
                });
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
      body: Container(
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
                    NowHeader('Admin console - All matches', fontSize: 20),
                    SizedBox(height: 15),
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
                isAdmin: true,
              ),
      ),
    );
  }
}
