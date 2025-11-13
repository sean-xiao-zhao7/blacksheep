import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:blacksheep/screens/register/register_screen_mentor_5.dart';
import 'package:blacksheep/screens/chat/mentor_chat_list_screen.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

final _firebase = FirebaseAuth.instance;

/// Login info for mentor
class RegisterScreenMentor6 extends StatefulWidget {
  const RegisterScreenMentor6(this.registerData, {super.key});
  final Map<String, dynamic> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor6> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> newData = {};
  Map<String, dynamic> userData = {};
  String errorCode = '';

  @override
  void initState() {
    _emailController.text =
        widget.registerData['email'] == null ||
            widget.registerData['email']!.isEmpty
        ? ""
        : widget.registerData['email']!;
    newData = {...widget.registerData};
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  bool submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      newData['email'] = _emailController.text.trim();
      return true;
    } else {
      return false;
    }
  }

  void completeRegister() async {
    errorCode = '';
    try {
      final userInfo = await _firebase.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      userData = {
        'email': userInfo.user!.email!,
        'uid': userInfo.user!.uid,
        'authToken': userInfo.user!.refreshToken,
        'firstName': widget.registerData['firstName']!,
        'lastName': widget.registerData['lastName']!,
        'age': widget.registerData['age']!,
        'gender': widget.registerData['gender']!,
        'exp': widget.registerData['exp']!,
        'stories': widget.registerData['stories']!,
        'crim': widget.registerData['crim']!,
        'church_name': widget.registerData['name']!,
        'address': widget.registerData['address']!,
        'long': widget.registerData['long']!,
        'longitude': widget.registerData['longitude']!,
        'latitude': widget.registerData['latitude']!,
        'phone': widget.registerData['phone']!,
        'type': 'mentor',
        'active': true,
      };
      DatabaseReference firebaseDatabaseRef = FirebaseDatabase.instance.ref(
        "users/${userInfo.user!.uid}",
      );
      await firebaseDatabaseRef.set(userData);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MentorChatListScreen(userData)),
        );
      }
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7ca2d),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(color: Color(0xfff7ca2d)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.only(
                top: 100,
                left: 50,
                right: 50,
                bottom: 100,
              ),
              decoration: BoxDecoration(
                color: Color(0xff9e607e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                  topRight: Radius.circular(200),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'RE-ENTER PASSWORD',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _password2Controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password re-enter is required.';
                        } else if (_passwordController.text.compareTo(
                              _passwordController.text,
                            ) !=
                            0) {
                          return "Both passwords must be equal.";
                        }
                        return null;
                      },
                      autocorrect: false,
                    ),
                    SmallButton('COMPLETE', () {
                      if (submit()) {
                        completeRegister();
                        if (errorCode != '') {
                          var message = '';
                          if (errorCode == 'weak-password') {
                            message = 'Password should be at least 6 chars.';
                          } else if (errorCode == 'email-already-in-use') {
                            message = 'Email already in use.';
                          }
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }
                      }
                    }, 0xff32a2c0),
                    SmallButton('BACK', () {
                      newData['email'] = _emailController.text;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterScreenMentor5(newData),
                        ),
                      );
                    }, 0xffffff),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: const NowHeader('LOGIN INFO'),
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
    );
  }
}
