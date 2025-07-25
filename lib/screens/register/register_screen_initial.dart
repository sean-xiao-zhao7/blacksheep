import 'package:flutter/widgets.dart';

import 'package:sheepfold/widgets/buttons/main_button.dart';
import 'package:sheepfold/widgets/layouts/genty_header.dart';

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
    return Container(
      padding: EdgeInsets.only(top: 150, bottom: 120),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/main/blacksheep_background_full.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        spacing: 20,
        children: [
          GentyHeader('REGISTRATION PAGE'),
          Spacer(),
          Text('I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY'),
          MainButton('CLICK HERE', () {}),
          Text('I AM THE LEADER OF A COMMUNITY GROUP'),
          MainButton('CLICK HERE', () {}),
        ],
      ),
    );
  }
}
