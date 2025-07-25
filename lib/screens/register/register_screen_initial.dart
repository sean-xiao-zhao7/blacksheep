import 'package:flutter/widgets.dart';

import 'package:sheepfold/widgets/buttons/main_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreenInitial extends StatefulWidget {
  const RegisterScreenInitial(this.switchScreen, {super.key});

  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenInitial> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 150),
      decoration: BoxDecoration(color: Color(0xff32a2c0)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          NowHeader('REGISTRATION PAGE'),
          Container(
            margin: EdgeInsets.only(top: 50),
            decoration: ShapeDecoration(
              shape: CircleBorder(side: BorderSide(color: Color(0xfffbee5e))),
            ),
            child: Image(image: AssetImage('assets/images/sheep.png')),
          ),
          Container(
            height: 500,
            padding: EdgeInsets.only(top: 30, left: 50, right: 50),
            decoration: BoxDecoration(color: Color(0xfffbee5e)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY'),
                SizedBox(height: 20),
                MainButton('CLICK HERE', () {}),
                SizedBox(height: 50),
                Text('I AM THE LEADER OF A COMMUNITY GROUP'),
                SizedBox(height: 20),
                MainButton('CLICK HERE', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
