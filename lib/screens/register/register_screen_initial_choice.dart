import 'package:blacksheep/screens/login/login_screen.dart';
import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:flutter/material.dart';

import 'package:blacksheep/screens/register/register_screen_mentee_2.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_2.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Choosing between mentee/mentor register screens
class RegisterScreenInitial extends StatefulWidget {
  const RegisterScreenInitial({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenInitial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff32a2c0),
      body: Container(
        padding: EdgeInsets.only(top: 70),
        decoration: BoxDecoration(color: Color(0xff32a2c0)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 140),
              padding: EdgeInsets.only(top: 80, left: 50, right: 50),
              decoration: BoxDecoration(
                color: Color(0xfffbee5e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                  topRight: Radius.circular(200),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  SmallButton('CLICK HERE', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => RegisterScreen2({})),
                    );
                  }, 0xff32a2c0),
                  SizedBox(height: 40),
                  Text(
                    'I AM THE LEADER OF A COMMUNITY GROUP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  SmallButton('CLICK HERE', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => RegisterScreenMentor2({}),
                      ),
                    );
                  }, 0xff062d69),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => LoginScreen()),
                      ),
                    },
                    child: NowText(
                      body: 'Login Instead',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: const NowHeader('REGISTRATION'),
            ),
            Positioned(
              top: 30,
              width: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/images/sheep.png'),
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
