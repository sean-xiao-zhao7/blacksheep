import 'package:flutter/material.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_3.dart';
import 'package:sheepfold/screens/register/register_screen_mentor_5.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreenMentor4 extends StatefulWidget {
  const RegisterScreenMentor4(this.registerData, {super.key});
  final Map<String, String> registerData;

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
  Map<String, String> newData = {};

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
      newData['exp'] = _experienceController.text;
      newData['stories'] = _storiesController.text;
      newData['crim'] = _criminalController.text;
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
              margin: EdgeInsets.only(top: 200),
              padding: EdgeInsets.only(
                top: 50,
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
                    Text(
                      'WHAT KIND OF EXPERIENCE\nDO YOU HAVE BEING A\nCOMMUNITY LEADER?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                      controller: _experienceController,
                      style: TextStyle(height: 2),
                      cursorHeight: 20,
                      maxLength: 2000,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Experience text is required.';
                        }
                      },
                      autocorrect: false,
                    ),
                    Text(
                      'ARE YOU ABLE TO PARALLEL BIBLE\nSTORIES AND THEIR LESSONS\nWITHIN A MODERN CONTEXT?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _storiesController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bible parallel text is required.';
                        }
                      },
                      autocorrect: false,
                    ),
                    Text(
                      'DO YOU HAVE A CRIMINAL RECORD?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
                      },
                      autocorrect: false,
                    ),
                    SmallButton('CONTINUE', () {
                      if (submit()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => RegisterScreenMentor5(newData),
                          ),
                        );
                      }
                    }, 0xff32a2c0),
                    SmallButton('BACK', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterScreenMentor3(newData),
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
                child: NowHeader('JUST A LITTLE MORE INFORMATION'),
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
    );
  }
}
