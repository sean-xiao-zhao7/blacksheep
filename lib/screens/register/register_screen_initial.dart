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
      padding: EdgeInsets.only(top: 120),
      decoration: BoxDecoration(color: Color(0xff32a2c0)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          NowHeader('REGISTRATION'),
          Stack(
            children: [
              Container(height: 766),
              Positioned(
                top: 120,
                bottom: 0,
                width: 430,
                child: Container(
                  padding: EdgeInsets.only(top: 100, left: 50, right: 50),
                  decoration: BoxDecoration(color: Color(0xfffbee5e)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      SmallButton('CLICK HERE', () {}, 0xff32a2c0),
                      SizedBox(height: 50),
                      Text(
                        'I AM THE LEADER OF A COMMUNITY GROUP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
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
              ),
              Positioned(
                top: 0,
                left: 100,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: EdgeInsets.only(top: 10),
                  child: Image(image: AssetImage('assets/images/sheep.png')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
