import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:blacksheep/screens/admin/admin_matches_list_screen.dart';

import 'package:blacksheep/screens/chat/mentee_chat_list_screen.dart';
import 'package:blacksheep/screens/chat/mentor_chat_list_screen.dart';
import 'package:blacksheep/screens/register/register_screen_initial.dart';

import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/genty_header.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> sessionData = {};
  String errorCode = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  void loginAsyncAction() async {
    setState(() {
      _isLoading = true;
    });
    errorCode = '';
    try {
      final userInfo = await _firebase.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // get userData from database
      final ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref
          .child("users/${userInfo.user!.uid}")
          .get();
      if (!snapshot.exists) {
        throw Error();
        // 'User with uid ${userInfo.user!.uid} does not exist in database even though it exists in auth.',
      }
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      sessionData = {};
      sessionData['uid'] = userInfo.user!.uid;
      sessionData['refreshToken'] = userInfo.user!.refreshToken!;
      sessionData['firstName'] = userData['firstName']!;
      sessionData['lastName'] = userData['lastName']!;
      sessionData['email'] = userData['email']!;
      sessionData['type'] = userData['type']!;
      sessionData['latitude'] = userData['latitude']!;
      sessionData['longitude'] = userData['longitude']!;
      sessionData['age'] = userData['age']!;
      sessionData['phone'] = userData['phone']!;

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              switch (userData['type']) {
                case 'mentor':
                  return MentorChatListScreen(sessionData);
                case 'mentee':
                  return MenteeChatListScreen(sessionData);
                case 'admin':
                  return AdminMatchesListScreen(userData: sessionData);
                default:
                  return MentorChatListScreen(sessionData);
              }
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
      if (mounted && errorCode != '') {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (errorCode == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid email(username) or password.')),
          );
        } else if (errorCode == 'invalid-email') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Email format invalid.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid login. Please try again later.')),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 200),
              padding: EdgeInsets.only(
                top: 30,
                left: 50,
                right: 50,
                bottom: 100,
              ),
              decoration: BoxDecoration(
                color: Color(0xfffbee5e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                  topRight: Radius.circular(200),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NowHeader('Please Login', color: Colors.black),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'EMAIL (username)',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required.';
                        }

                        return null;
                      },
                      autocorrect: false,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required.';
                        }
                        return null;
                      },
                      autocorrect: false,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : SmallButton('Login', () {
                            if (submit()) {
                              loginAsyncAction();
                            }
                          }, 0xff32a2c0),
                    SmallButton('Register', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterScreenInitial(),
                        ),
                      );
                    }, 0xff32a2c0),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              width: MediaQuery.of(context).size.width,
              child: const GentyHeader('BlackSheep', fontSize: 70),
            ),
            Positioned(
              top: 40,
              width: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/images/sheep.png'),
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
