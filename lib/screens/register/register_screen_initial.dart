import 'package:flutter/material.dart';
import 'package:blacksheep/screens/home_screen.dart';
import 'package:blacksheep/screens/register/register_screen_2.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_2.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

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
      body: ListView(
        children: [
          Container(
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
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SmallButton('CLICK HERE', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => RegisterScreen2({}),
                          ),
                        );
                      }, 0xff32a2c0),
                      SizedBox(height: 30),
                      Text(
                        'I AM THE LEADER OF A COMMUNITY GROUP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SmallButton('CLICK HERE', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => RegisterScreenMentor2({}),
                          ),
                        );
                      }, 0xff062d69),
                      SizedBox(height: 30),
                      SmallButton('BACK', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return HomeScreen();
                            },
                          ),
                        );
                      }, 0xffffff),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  width: MediaQuery.of(context).size.width,
                  child: const NowHeader('REGISTRATION'),
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
          ),
        ],
      ),
    );
  }
}
