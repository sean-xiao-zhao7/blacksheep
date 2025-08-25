import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_5.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

final _firebase = FirebaseAuth.instance;

class RegisterScreenMentor6 extends StatefulWidget {
  const RegisterScreenMentor6(this.registerData, {super.key});
  final Map<String, String> registerData;

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
  Map<String, String> newData = {};

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
      newData['email'] = _emailController.text;
      return true;
    } else {
      return false;
    }
  }

  void completeRegister() async {
    try {
      final userInfo = _firebase.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print(userInfo);
    } on FirebaseAuthException catch (e) {
      print('Error register.');
      print(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      },
                      autocorrect: false,
                    ),
                    SmallButton('COMPLETE', () {
                      if (submit()) {
                        completeRegister();
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
