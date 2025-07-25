import 'package:flutter/widgets.dart';

import 'package:sheepfold/widgets/buttons/main_button.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
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
      padding: EdgeInsets.only(top: 140),
      decoration: BoxDecoration(color: Color(0xff32a2c0)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          NowHeader('REGISTRATION'),
          Container(
            margin: EdgeInsets.only(top: 20),
            foregroundDecoration: ShapeDecoration(
              shape: CircleBorder(side: BorderSide(color: Color(0xfffbee5e))),
            ),
            child: Image(image: AssetImage('assets/images/sheep.png')),
          ),
          Container(
            height: 512,
            padding: EdgeInsets.only(top: 50, left: 50, right: 50),
            decoration: BoxDecoration(color: Color(0xfffbee5e)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20),
                SmallButton('CLICK HERE', () {}, 0xff32a2c0),
                SizedBox(height: 50),
                Text(
                  'I AM THE LEADER OF A COMMUNITY GROUP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20),
                SmallButton('CLICK HERE', () {}, 0xff062d69),
                SizedBox(height: 20),
                SmallButton('BACK', () {
                  widget.switchScreen('home', 'home_screen');
                }, 0xffffff),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
