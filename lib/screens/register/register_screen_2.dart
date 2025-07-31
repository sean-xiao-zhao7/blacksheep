import 'package:flutter/material.dart';

import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2(this.switchScreen, {super.key});

  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreen2> {
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
            decoration: BoxDecoration(
              color: Color(0xfffbee5e),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200),
                topRight: Radius.circular(200),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First name'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last name'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                SmallButton('SUBMIT', () {
                  widget.switchScreen('register', 'register_screen_2');
                }, 0xff32a2c0),

                SmallButton('BACK', () {
                  widget.switchScreen('register', 'register_screen_initial');
                }, 0xffffff),
              ],
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: const NowHeader('SIGN UP TODAY!'),
          ),
          Positioned(
            top: 40,
            width: MediaQuery.of(context).size.width,
            child: const Image(
              image: AssetImage('assets/images/sheep.png'),
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
