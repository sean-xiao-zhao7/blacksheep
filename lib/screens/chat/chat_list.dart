import "package:flutter/material.dart";
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
        title: NowHeader('BlackSheep ', color: Colors.black),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
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
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: NowHeader('Welcome $firstName!'),
                ),
        ),
      ),
    );
  }
}
