import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sheepfold/screens/chat/chat_list.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/genty_header.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _loginScreenState();
  }
}

class _loginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    try {
      final userInfo = await _firebase.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // get userData from database
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child("users/${userInfo.user!.uid}").get();
      if (!snapshot.exists) {
        throw Error();
        // 'User with uid ${userInfo.user!.uid} does not exist in database even though it exists in auth.',
      }
      final userData = snapshot.value;
      final Map<String, String> sessionData = {};
      sessionData['uid'] = userInfo.user!.uid;
      sessionData['refreshToken'] = userInfo.user!.refreshToken!;
      // sessionData['email'] = userData!.;
      print(userData);

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => ChatList(sessionData)));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      ScaffoldMessenger.of(context).clearSnackBars();
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email or password invalid.')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email format invalid.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid login. Please try again later.')),
        );
      }
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
                      },
                      autocorrect: false,
                    ),
                    SmallButton('Login', () {
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
