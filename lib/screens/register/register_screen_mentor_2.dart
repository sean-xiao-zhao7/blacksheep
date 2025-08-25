import 'package:flutter/material.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_3.dart';

import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreenMentor2 extends StatefulWidget {
  const RegisterScreenMentor2(this.registerData, {super.key});
  final Map<String, String> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor2> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, String> newData = {};

  @override
  void initState() {
    _firstNameController.text =
        widget.registerData['firstName'] == null ||
            widget.registerData['firstName']!.isEmpty
        ? ""
        : widget.registerData['firstName']!;
    _lastNameController.text =
        widget.registerData['lastName'] == null ||
            widget.registerData['lastName']!.isEmpty
        ? ""
        : widget.registerData['lastName']!;
    _ageController.text =
        widget.registerData['age'] == null ||
            widget.registerData['age']!.isEmpty
        ? ""
        : widget.registerData['age']!;
    _genderController.text =
        widget.registerData['gender'] == null ||
            widget.registerData['gender']!.isEmpty
        ? ""
        : widget.registerData['gender']!;
    _phoneController.text =
        widget.registerData['phone'] == null ||
            widget.registerData['phone']!.isEmpty
        ? ""
        : widget.registerData['phone']!;
    newData = {...widget.registerData};
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      newData['firstName'] = _firstNameController.text;
      newData['lastName'] = _lastNameController.text;
      newData['age'] = _ageController.text;
      newData['gender'] = _genderController.text;
      newData['phone'] = _phoneController.text;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 80),
        decoration: BoxDecoration(color: Color(0xfff7ca2d)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.only(
                top: 100,
                left: 50,
                right: 50,
                bottom: 50,
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
                      autocorrect: false,
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required.';
                        }
                      },
                      autocorrect: false,
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
                      controller: _ageController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Age is required.';
                        }
                      },
                      autocorrect: false,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'PHONE',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required.';
                        }
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        RadioListTile(
                          title: Text("MALE"),
                          value: 'MALE',
                          groupValue: _genderController.text,
                          onChanged: (value) {
                            setState(() {
                              _genderController.text = value!;
                            });
                          },
                          activeColor: Color(0xff32a2c0),
                        ),
                        RadioListTile(
                          title: Text("FEMALE"),
                          value: 'FEMALE',
                          groupValue: _genderController.text,
                          onChanged: (value) {
                            setState(() {
                              _genderController.text = value!;
                            });
                          },
                          activeColor: Color(0xff32a2c0),
                        ),
                      ],
                    ),
                    SmallButton('CONTINUE', () {
                      if (submit()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => RegisterScreenMentor3(newData),
                          ),
                        );
                      }
                    }, 0xff32a2c0),
                    SmallButton('BACK', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterScreenInitial(),
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: NowHeader('SIGN UP AS A COMMUNITY MENTOR'),
              ),
            ),
            Positioned(
              top: 30,
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
