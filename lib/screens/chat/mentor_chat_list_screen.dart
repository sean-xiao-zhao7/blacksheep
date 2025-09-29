import "package:flutter/material.dart";
import 'package:flutter_email_sender/flutter_email_sender.dart';

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

import "package:sheepfold/screens/login/login_screen.dart";
import "package:sheepfold/widgets/layouts/headers/genty_header.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";
import 'package:sheepfold/screens/chat/mentor_chat_preview_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _getChats();
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

      List<MentorChatPreviewWidget> newChatPreviewsList = [];
      for (final String key in allChats.keys) {
        var currentChat = allChats[key];
        currentChat['chatId'] = key;
        if (widget.userData['type'] == 'mentor' &&
            currentChat['mentorUid'] == widget.userData['uid']) {
          currentChat['isMentor'] = true;
        }

        MentorChatPreviewWidget currentChatPreview = MentorChatPreviewWidget(
          chatInfo: currentChat,
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
            : Container(
                padding: EdgeInsets.all(10),
                child: ListView(children: _chatsPreviewList),
              )),
      ),
    );
  }
}
