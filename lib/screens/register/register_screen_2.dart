import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      padding: EdgeInsets.only(top: 120),
      decoration: BoxDecoration(color: Color(0xff32a2c0)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          NowHeader('SIGN UP TODAY!'),
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
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'First name',
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      SmallButton('SUBMIT', () {
                        widget.switchScreen('register', 'register_screen_2');
                      }, 0xff32a2c0),

                      SmallButton('BACK', () {
                        widget.switchScreen(
                          'register',
                          'register_screen_initial',
                        );
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
