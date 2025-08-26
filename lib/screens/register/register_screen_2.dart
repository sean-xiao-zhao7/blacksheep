import 'package:flutter/material.dart';
import 'package:sheepfold/screens/register/register_screen_3.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';
import 'package:flutter/services.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2(this.registerData, {super.key});
  final Map<String, String> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreen2> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();

  // form
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
        : widget.registerData['firstName']!;
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
    newData = {...widget.registerData};
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
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
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
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
                            builder: (ctx) =>
                                RegisterScreen3(registerData: newData),
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
      ),
    );
  }
}
