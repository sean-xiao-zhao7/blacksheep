import 'package:flutter/widgets.dart';

// screens
import 'package:sheepfold/screens/home_screen.dart';
import 'package:sheepfold/screens/register/register_screen_3.dart';
import 'package:sheepfold/screens/register/register_screen_4.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';
import 'package:sheepfold/screens/register/register_screen_2.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_2.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_3.dart';

class BlacksheepSuperWidget extends StatefulWidget {
  const BlacksheepSuperWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BlacksheepSuperWidgetState();
  }
}

class _BlacksheepSuperWidgetState extends State<BlacksheepSuperWidget> {
  var currentGroup = 'home';
  var currentScreen = 'home_screen';

  void switchScreen(newGroup, newScreen) {
    if (newGroup != null && newScreen != null) {
      setState(() {
        currentGroup = newGroup;
        currentScreen = newScreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (currentGroup) {
      case 'home':
        switch (currentScreen) {
          case 'home_screen':
            screen = HomeScreen(switchScreen);
          default:
            screen = HomeScreen(switchScreen);
        }
      case 'register':
        switch (currentScreen) {
          case 'register_screen_initial':
            screen = RegisterScreenInitial(switchScreen);
          case 'register_screen_2':
            screen = RegisterScreen2(switchScreen);
          case 'register_screen_3':
            screen = RegisterScreen3(switchScreen);
          case 'register_screen_4':
            screen = RegisterScreen4(switchScreen);
          case 'register_screen_mentor_2':
            screen = RegisterScreenMentor2(switchScreen);
          case 'register_screen_mentor_3':
            screen = RegisterScreenMentor3(switchScreen);
          case 'register_screen_mentor_4':
            screen = RegisterScreen4(switchScreen);
          default:
            screen = RegisterScreenInitial(switchScreen);
        }
      default:
        screen = HomeScreen(switchScreen);
    }
    return screen;
  }
}
