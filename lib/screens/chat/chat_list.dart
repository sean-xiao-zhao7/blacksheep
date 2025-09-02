import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:sheepfold/screens/login/login_screen.dart";
import "package:sheepfold/widgets/buttons/main_button.dart";
import "package:sheepfold/widgets/layouts/headers/genty_header.dart";
import "package:sheepfold/widgets/layouts/headers/now_header.dart";

class ChatList extends StatefulWidget {
  const ChatList(this.userData, {super.key});
  final Map<String, String> userData;

  @override
  State<StatefulWidget> createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void connectToMentor(String type) {}

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
              showBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox.expand(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[Text(widget.userData['firstName']!)],
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
              decoration: BoxDecoration(color: Color(0xff32a2c0)),
              child: GentyHeader('BlackSheep', fontSize: 30),
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
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: _isLoading
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
                    SizedBox(height: 20),
                    NowHeader('Welcome $firstName!', fontSize: 28),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xff32a2c0).withAlpha(210),
                      ),
                      child: NowHeader(
                        'Start connecting with a mentor by selecting one of the choices below:',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 210),
                    MainButton('Connect by phone', connectToMentor, size: 400),
                    MainButton(
                      'Connect by chat app',
                      connectToMentor,
                      size: 400,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
