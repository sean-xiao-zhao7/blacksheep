import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:blacksheep/screens/login/login_screen.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/genty_header.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

final _firebase = FirebaseAuth.instance;

/// Use Firebase to reset password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorCode = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  void recoverPasswordAsyncAction() async {
    setState(() {
      _isLoading = true;
    });
    _errorCode = '';
    try {
      await _firebase.sendPasswordResetEmail(email: _emailController.text);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please check your email.')));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return LoginScreen();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _errorCode = e.code;
      if (mounted && _errorCode != '') {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (_errorCode == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid email(username) or password.')),
          );
        } else if (_errorCode == 'invalid-email') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Email format invalid.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error recovering password. Please try later.'),
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
                top: 150,
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
                  spacing: 40,
                  children: [
                    NowHeader('Recover password', color: Colors.black),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'EMAIL (username)',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Now',
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
                    Column(
                      children: [
                        _isLoading
                            ? CircularProgressIndicator()
                            : SmallButton('Recover via email', () {
                                if (submit()) {
                                  recoverPasswordAsyncAction();
                                }
                              }, 0xff32a2c0),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => LoginScreen(),
                              ),
                            ),
                          },
                          child: NowText(
                            body: 'Back to login',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
