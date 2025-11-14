import 'package:flutter/material.dart';

import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_3.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_5.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Faith questions for mentor
class RegisterScreenMentor4 extends StatefulWidget {
  const RegisterScreenMentor4(this.registerData, {super.key});
  final Map<String, dynamic> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor4> {
  final _experienceController = TextEditingController();
  final _storiesController = TextEditingController();
  final _criminalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> newData = {};

  @override
  void initState() {
    _experienceController.text =
        widget.registerData['exp'] == null ||
            widget.registerData['exp']!.isEmpty
        ? ""
        : widget.registerData['exp']!;
    _storiesController.text =
        widget.registerData['stories'] == null ||
            widget.registerData['stories']!.isEmpty
        ? ""
        : widget.registerData['stories']!;
    _criminalController.text =
        widget.registerData['crim'] == null ||
            widget.registerData['crim']!.isEmpty
        ? ""
        : widget.registerData['crim']!;
    newData = {...widget.registerData};
    super.initState();
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _storiesController.dispose();
    _criminalController.dispose();
    super.dispose();
  }

  bool submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      newData['exp'] = _experienceController.text.trim();
      newData['stories'] = _storiesController.text.trim();
      newData['crim'] = _criminalController.text.trim();
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
                  margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.only(
                    top: 100,
                    left: 30,
                    right: 30,
                    bottom: 150,
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
                      spacing: 10,
                      children: [
                        Text(
                          'WHAT KIND OF EXPERIENCE DO YOU HAVE BEING A COMMUNITY LEADER?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Now',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            counterStyle: TextStyle(color: Colors.white),
                          ),
                          maxLines: 3,
                          controller: _experienceController,
                          cursorHeight: 20,
                          maxLength: 2000,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Experience text is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontFamily: 'Now',
                            height: 2,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ARE YOU ABLE TO PARALLEL BIBLE STORIES AND THEIR LESSONS WITHIN A MODERN CONTEXT?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Now',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _storiesController,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Bible parallel text is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'DO YOU HAVE A CRIMINAL RECORD?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Now',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _criminalController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Criminal record text is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10),
                        SmallButton('CONTINUE', () {
                          if (submit()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    RegisterScreenMentor5(newData),
                              ),
                            );
                          }
                        }, 0xff32a2c0),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    RegisterScreenMentor3(newData),
                              ),
                            ),
                          },
                          child: NowText(
                            body: 'BACK',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: NowHeader(
                      'JUST A LITTLE MORE INFORMATION',
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
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
