import "package:flutter/material.dart";
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
        title: GentyHeader('BlackSheep', fontSize: 40),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff32a2c0),        
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
                    NowHeader('Welcome $firstName!', fontSize: 28,),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xff32a2c0).withAlpha(210),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: NowHeader(
                        'Start connecting with a mentor by selecting one of the choices below:',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
