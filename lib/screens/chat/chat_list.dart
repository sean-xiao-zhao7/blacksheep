import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import 'dart:math';
import "package:flutter/material.dart";
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

  @override
  void initState() {
    super.initState();
  }

  void connectToMentor(String type) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users').get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> allUsers = snapshot.value as Map<dynamic, dynamic>;

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
      print('$closestUid, $closestDistance');
    } else {
      print('No mentors.');
    }
  }

  void getChats(String type) {
    // make database connection
  }

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
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: userType == 'mentee'
            ? SingleChildScrollView(
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
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Color(0xff32a2c0).withAlpha(210),
                            ),
                            child: NowHeader(
                              'Start connecting with a mentor by selecting one of the choices below:',
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 200),
                          MainButton(
                            'Connect by phone',
                            () => connectToMentor('phone'),
                            size: 400,
                          ),
                          MainButton(
                            'Connect by chat app',
                            () => connectToMentor('chat'),
                            size: 400,
                          ),
                        ],
                      ),
              )
            : SingleChildScrollView(
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
                          SizedBox(height: 5),
                          NowHeader('Welcome $firstName!', fontSize: 26),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xff32a2c0).withAlpha(210),
                            ),
                            child: NowHeader(
                              'As mentor, you can chat with mentees who connected with you below:',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          menteeCount == 0
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff32a2c0).withAlpha(210),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(top: 150),
                                  child: NowHeader(
                                    'No mentees connected yet. Please check back later!',
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              : ListView(children: []),
                        ],
                      ),
              ),
      ),
    );
  }
}
