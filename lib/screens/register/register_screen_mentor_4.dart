import 'package:flutter/material.dart';

import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreenMentor4 extends StatefulWidget {
  const RegisterScreenMentor4(this.switchScreen, {super.key});

  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor4> {
  final _experienceController = TextEditingController();
  final _storiesController = TextEditingController();
  final _criminalController = TextEditingController();

  @override
  void dispose() {
    _experienceController.dispose();
    _storiesController.dispose();
    _criminalController.dispose();
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
            padding: EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 50),
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
                Text(
                  'WHAT KIND OF EXPERIENCE\nDO YOU HAVE BEING A\nCOMMUNITY LEADER?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),                
                TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                  controller: _experienceController,
                  style: TextStyle(height: 2),
                  cursorHeight: 20,
                  maxLength: 2000,                  
                ),               
                Text(
                  'ARE YOU ABLE TO PARALLEL BIBLE\nSTORIES AND THEIR LESSONS\nWITHIN A MODERN CONTEXT?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),                
                TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: _storiesController,
                ),                
                Text(
                  'DO YOU HAVE A CRIMINAL RECORD?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: _storiesController,
                ),
                SmallButton('CONTINUE', () {
                  widget.switchScreen('register', 'register_screen_mentor_5');
                }, 0xff32a2c0),

                SmallButton('BACK', () {
                  widget.switchScreen('register', 'register_screen_mentor_3');
                }, 0xffffff),
              ],
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: NowHeader('JUST A LITTLE MORE INFORMATION'),
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
