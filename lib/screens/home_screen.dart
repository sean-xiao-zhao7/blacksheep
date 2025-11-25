import 'package:flutter/material.dart';

import 'package:blacksheep/screens/login/login_screen.dart';
import 'package:blacksheep/screens/register/register_screen_initial_choice.dart';
import 'package:blacksheep/widgets/buttons/main_button.dart';
import 'package:blacksheep/widgets/layouts/headers/genty_header.dart';

/// Show a beautiful screen with sheep at start
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 150, bottom: 120),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/blacksheep_background_full.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        spacing: 20,
        children: [
          GentyHeader('BlackSheep'),
          Spacer(),
          MainButton('REGISTER', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => RegisterScreenInitial()),
            );
          }),
          MainButton('LOGIN', () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => LoginScreen()),
            );
          }),
        ],
      ),
    );
  }
}
