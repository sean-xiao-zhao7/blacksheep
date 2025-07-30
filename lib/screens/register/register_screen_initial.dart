import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(color: Color(0xff32a2c0)),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 150),
            padding: EdgeInsets.only(
              top: 100,
              left: 50,
              right: 50,
              bottom: 200,
            ),
            decoration: BoxDecoration(color: Color(0xfffbee5e)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SmallButton('CLICK HERE', () {
                  widget.switchScreen('register', 'register_screen_2');
                }, 0xff32a2c0),
                Text(
                  'I AM THE LEADER OF A COMMUNITY GROUP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),

                SmallButton('CLICK HERE', () {}, 0xff062d69),

                SmallButton('BACK', () {
                  widget.switchScreen('home', 'home_screen');
                }, 0xffffff),
              ],
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: NowHeader('REGISTRATION'),
          ),
          Positioned(
            top: -50,
            width: MediaQuery.of(context).size.width,
            child: Image(image: AssetImage('assets/images/sheep.png')),
          ),
        ],
      ),
    );
  }
}
