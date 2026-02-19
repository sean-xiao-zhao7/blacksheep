import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:blacksheep/screens/login/forgot_password_screen.dart';
import 'package:blacksheep/screens/admin/admin_chat_list_screen.dart';
import 'package:blacksheep/screens/chat/mentee_chat_list_screen.dart';
import 'package:blacksheep/screens/chat/mentor_chat_list_screen.dart';
import 'package:blacksheep/screens/register/register_screen_initial_choice.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/genty_header.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

final _firebaseAuth = FirebaseAuth.instance;

/// Login using Firebase Auth
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
      final userInfo = await _firebaseAuth.signInWithEmailAndPassword(
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
      sessionData['refreshToken'] = userInfo.user!.refreshToken;
      sessionData['firstName'] = userData['firstName']!;
      sessionData['lastName'] = userData['lastName']!;
      sessionData['email'] = userData['email']!;
      sessionData['type'] = userData['type']!;
      sessionData['latitude'] = userData['latitude']!;
      sessionData['longitude'] = userData['longitude']!;
      sessionData['age'] = userData['age']!;
      sessionData['phone'] = userData['phone']!;
      sessionData['chatId'] = userData['chatId'] ?? "";
      sessionData['active'] = userData['active'] ?? false;

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              switch (userData['type']) {
                case 'mentor':
                  return MentorChatListScreen(sessionData);
                case 'mentee':
                  return MenteeChatListScreen(sessionData);
                case 'admin':
                  return AdminChatListScreen(userData: sessionData);
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
            SnackBar(
              content: NowText(
                body: 'Invalid email(username) or password.',
                color: Colors.white,
              ),
            ),
          );
        } else if (errorCode == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: NowText(
                body: 'Email format invalid.',
                color: Colors.white,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: NowText(
                body: 'Invalid login. Please try again later.',
                color: Colors.white,
              ),
            ),
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
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 160),
              padding: EdgeInsets.only(
                top: 120,
                left: 50,
                right: 50,
                bottom: 0,
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
                  children: [
                    NowHeader(
                      'Please Login',
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'EMAIL (username)',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Now',
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Now',
                        fontWeight: FontWeight.bold,
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
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Now',
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Now',
                        fontWeight: FontWeight.bold,
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
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : SmallButton('Login', () {
                            if (submit()) {
                              loginAsyncAction();
                            }
                          }, 0xff32a2c0),
                    SizedBox(height: 20),
                    SmallButton('Register', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterScreenInitial(),
                        ),
                      );
                    }, 0xff32a2c0),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ForgotPasswordScreen(),
                          ),
                        ),
                      },
                      child: NowText(
                        body: 'Forgot password?',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50,
              width: MediaQuery.of(context).size.width,
              child: const GentyHeader('BlackSheep', fontSize: 70),
            ),
            Positioned(
              top: 30,
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
