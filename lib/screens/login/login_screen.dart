import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/genty_header.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen(this.switchScreen, {super.key});
  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _loginScreenState();
  }
}

class _loginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

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
      final userInfo = _firebase.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print(userInfo);
    } on FirebaseAuthException catch (e) {
      print('Error login.');
      print(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(color: Color(0xfffbee5e)),
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/blacksheep_background_full.png",
                ),
                fit: BoxFit.cover,
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
                  SmallButton('Login', () {
                    if (submit()) {
                      loginAsyncAction();
                    }
                  }, 0xff32a2c0),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: const GentyHeader('BLACKSHEEP'),
          ),
        ],
      ),
    );
  }
}
