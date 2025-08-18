import 'package:flutter/material.dart';

import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2(this.switchScreen, {super.key});

  final Function switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreen2> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageNameController = TextEditingController();
  final _genderNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageNameController.dispose();
    _genderNameController.dispose();
    super.dispose();
  }

  void submit() {
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(color: Color(0xff32a2c0)),
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
              color: Color(0xfffbee5e),
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
                      labelText: 'FIRST NAME',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required.';
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'LAST NAME',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _lastNameController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'AGE',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _ageNameController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'GENDER',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _genderNameController,
                  ),
                  SmallButton('CONTINUE', () {
                    submit();
                    widget.switchScreen('register', 'register_screen_3');
                  }, 0xff32a2c0),

                  SmallButton('BACK', () {
                    widget.switchScreen('register', 'register_screen_initial');
                  }, 0xffffff),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: const NowHeader('SIGN UP TODAY!'),
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
