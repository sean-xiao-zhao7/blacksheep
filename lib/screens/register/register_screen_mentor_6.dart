import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

final _firebase = FirebaseAuth.instance;

class RegisterScreenMentor6 extends StatefulWidget {
  const RegisterScreenMentor6(this.switchScreen, {super.key});

  final Function switchScreen;

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
  String _email = '';
  String _password = '';
  String _password_reenter = '';

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
      return true;
    } else {
      return false;
    }
  }

  void completeRegister() async {
    try {
      final userInfo = _firebase.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error register.');
      print(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    onSaved: (value) {
                      _email = value!;
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
                    onSaved: (value) {
                      _password = value!;
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
                      print(_password.compareTo(_password_reenter));
                      if (value == null || value.trim().isEmpty) {
                        return 'Password re-enter is required.';
                      } else if (_password.compareTo(_password_reenter) != 0) {
                        return "Both passwords must be equal.";
                      }
                    },
                    onSaved: (value) {
                      _password_reenter = value!;
                    },
                    autocorrect: false,
                  ),
                  SmallButton('COMPLETE', () {
                    if (submit()) {
                      completeRegister();
                    }
                  }, 0xff32a2c0),
                  SmallButton('BACK', () {
                    widget.switchScreen('register', 'register_screen_mentor_5');
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
    );
  }
}
