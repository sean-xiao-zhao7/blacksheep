import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreenMentor3 extends StatefulWidget {
  const RegisterScreenMentor3(this.switchScreen, {super.key});

  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor3> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _longController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80),
      decoration: BoxDecoration(color: Color(0xfff7ca2d)),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 200),
            padding: EdgeInsets.only(
              top: 100,
              left: 50,
              right: 50,
              bottom: 100,
            ),
            decoration: BoxDecoration(
              color: Color(0xff9e607e),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200),
                topRight: Radius.circular(200),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'NAME OF YOUR CHURCH',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: _nameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'FULL CHURCH ADDRESS',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: _addressController,
                  maxLines: 2,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'HOW LONG HAVE YOU\nBEEN A FOLLOWER OF CHRIST?',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Colors.white,                    
                  ),
                  controller: _longController,
                  style: TextStyle(height: 3),
                  cursorHeight: 20,
                ),
                SmallButton('CONTINUE', () {
                  widget.switchScreen('register', 'register_screen_mentor_4');
                }, 0xff32a2c0),

                SmallButton('BACK', () {
                  widget.switchScreen('register', 'register_screen_mentor_2');
                }, 0xffffff),
              ],
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: NowHeader('WHICH CHURCH DO YOU ATTEND?'),
            ),
          ),
          Positioned(
            top: 60,
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
