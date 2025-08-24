import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// screens
import 'package:sheepfold/screens/home_screen.dart';
import 'package:sheepfold/screens/login/login_screen.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';
import 'package:sheepfold/screens/register/register_screen_2.dart';
import 'package:sheepfold/screens/register/register_screen_3.dart';
import 'package:sheepfold/screens/register/register_screen_4.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_2.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_3.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_4.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_5.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_6.dart';
import 'package:sheepfold/screens/chat/chat_list.dart';
import 'package:sheepfold/screens/chat/single_chat.dart';
import 'package:sheepfold/screens/splash_screen.dart';

class BlacksheepRouter extends StatefulWidget {
  const BlacksheepRouter({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BlacksheepRouter();
  }
}

class _BlacksheepRouter extends State<BlacksheepRouter> {
  var currentGroup = 'home';
  var currentScreen = 'splash_screen';
  var _loading = false;

  void switchScreen(newGroup, newScreen) {
    if (currentScreen == 'login_screen') {
      setState(() {
        _loading = true;
      });
      if (newGroup != null && newScreen != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            currentGroup = newGroup;
            currentScreen = newScreen;
            _loading = false;
          });
        });
      }
    } else {
      setState(() {
        currentGroup = newGroup;
        currentScreen = newScreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    // splash screen on initial load
    if (currentScreen == 'splash_screen') {
      return SplashScreen(switchScreen);
    }

    switch (currentGroup) {
      case 'register':
        switch (currentScreen) {
          case 'register_screen_initial':
            screen = RegisterScreenInitial(switchScreen);
          case 'register_screen_2':
            screen = RegisterScreen2(switchScreen, {});
          case 'register_screen_3':
            screen = RegisterScreen3(switchScreen);
          case 'register_screen_4':
            screen = RegisterScreen4(switchScreen);
          case 'register_screen_mentor_2':
            screen = RegisterScreenMentor2(switchScreen);
          case 'register_screen_mentor_3':
            screen = RegisterScreenMentor3(switchScreen);
          case 'register_screen_mentor_4':
            screen = RegisterScreenMentor4(switchScreen);
          case 'register_screen_mentor_5':
            screen = RegisterScreenMentor5(switchScreen);
          case 'register_screen_mentor_6':
            screen = RegisterScreenMentor6(switchScreen);
          default:
            screen = RegisterScreenInitial(switchScreen);
        }
      case 'login':
        switch (currentScreen) {
          case 'login_screen':
            screen = LoginScreen(switchScreen);
          default:
            screen = LoginScreen(switchScreen);
        }
      case 'chat':
        switch (currentScreen) {
          case 'chat_list':
            screen = ChatList(switchScreen);
          case 'single_chat':
            screen = SingleChat(switchScreen);
          default:
            screen = ChatList(switchScreen);
        }
      default:
        screen = HomeScreen();
    }

    if (_loading) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    } else {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (currentGroup == 'chat' && !snapshot.hasData) {
            return LoginScreen(switchScreen);
          } else {
            return screen;
          }
        },
      );
    }
  }
}
