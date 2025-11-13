import 'package:flutter/material.dart';

import 'package:blacksheep/screens/register/register_screen_mentor_2.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_4.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Church info for mentor
class RegisterScreenMentor3 extends StatefulWidget {
  const RegisterScreenMentor3(this.registerData, {super.key});
  final Map<String, dynamic> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor3> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _longController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> newData = {};

  @override
  void initState() {
    _nameController.text =
        widget.registerData['name'] == null ||
            widget.registerData['name']!.isEmpty
        ? ""
        : widget.registerData['name']!;
    _addressController.text =
        widget.registerData['address'] == null ||
            widget.registerData['address']!.isEmpty
        ? ""
        : widget.registerData['address']!;
    _longController.text =
        widget.registerData['long'] == null ||
            widget.registerData['long']!.isEmpty
        ? ""
        : widget.registerData['long']!;
    newData = {...widget.registerData};
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _longController.dispose();
    super.dispose();
  }

  bool submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      newData['name'] = _nameController.text.trim();
      newData['address'] = _addressController.text.trim();
      newData['long'] = _longController.text.trim();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7ca2d),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(color: Color(0xfff7ca2d)),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 170),
                  padding: EdgeInsets.only(
                    top: 130,
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
                            labelText: 'NAME OF YOUR CHURCH',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Church name is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'FULL CHURCH ADDRESS',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _addressController,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Address is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText:
                                'HOW LONG HAVE YOU\nBEEN A FOLLOWER OF CHRIST?',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _longController,
                          style: TextStyle(height: 3),
                          cursorHeight: 20,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'How long at church is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 30),
                        SmallButton('CONTINUE', () {
                          if (submit()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    RegisterScreenMentor4(newData),
                              ),
                            );
                          }
                        }, 0xff32a2c0),
                        SizedBox(height: 10),
                        SmallButton('BACK', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => RegisterScreenMentor2(newData),
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
                    child: NowHeader('WHICH CHURCH DO YOU ATTEND?'),
                  ),
                ),
                Positioned(
                  top: 60,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage('assets/images/sheep.png'),
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
