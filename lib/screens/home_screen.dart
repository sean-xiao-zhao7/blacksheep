import 'package:flutter/widgets.dart';

import 'package:sheepfold/widgets/buttons/main_button.dart';
import 'package:sheepfold/widgets/layouts/headers/genty_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.switchScreen, {super.key});

  final Function switchScreen;

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
            widget.switchScreen('register', 'register_screen_initial');
          }),
          MainButton('LOGIN', () {
            widget.switchScreen('login', 'login_screen');
          }),
        ],
      ),
    );
  }
}
