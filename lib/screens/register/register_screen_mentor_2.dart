import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:blacksheep/screens/register/register_screen_initial_choice.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_3.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Personal info for mentor
class RegisterScreenMentor2 extends StatefulWidget {
  const RegisterScreenMentor2(this.registerData, {super.key});
  final Map<String, dynamic> registerData;

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
  Map<String, dynamic> newData = {};
  double latitude = 0;
  double longitude = 0;
  bool _isLoading = false;

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
    latitude = widget.registerData['latitude'] == null
        ? 0
        : widget.registerData['latitude']! as double;
    longitude = widget.registerData['longitude'] == null
        ? 0
        : widget.registerData['longitude']! as double;
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
    bool isValid = _formKey.currentState!.validate();
    if (latitude == 0 && longitude == 0) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Current location is required.')));
      isValid = false;
    }

    if (isValid) {
      _formKey.currentState!.save();
      newData['firstName'] = _firstNameController.text.trim();
      newData['lastName'] = _lastNameController.text.trim();
      newData['age'] = _ageController.text.trim();
      newData['gender'] = _genderController.text.trim();
      newData['phone'] = _phoneController.text.trim();
      newData['latitude'] = latitude;
      newData['longitude'] = longitude;
      return true;
    } else {
      return false;
    }
  }

  void getLocationAsync() async {
    setState(() {
      _isLoading = true;
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }
    LocationData locationData = await location.getLocation();
    setState(() {
      latitude = locationData.latitude!;
      longitude = locationData.longitude!;
      _isLoading = false;
    });
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
                    top: 120,
                    left: 30,
                    right: 30,
                    bottom: 200,
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
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'FIRST NAME',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Now',
                              fontWeight: FontWeight.bold,
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
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(fontSize: 18),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'LAST NAME',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Now',
                              fontWeight: FontWeight.bold,
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
                            return null;
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(fontSize: 18),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'AGE',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Now',
                              fontWeight: FontWeight.bold,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                            counterText: "",
                          ),
                          controller: _ageController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Age is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 2,
                          style: TextStyle(fontSize: 18),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'PHONE',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Now',
                              fontWeight: FontWeight.bold,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                            counterText: "",
                          ),
                          controller: _phoneController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone number is required.';
                            }
                            return null;
                          },
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            MaskTextInputFormatter(
                              mask: '(###) ###-####',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy,
                            ),
                          ],
                          maxLength: 14,
                          style: TextStyle(fontSize: 18),
                        ),
                        Column(
                          children: [
                            RadioListTile(
                              dense: true,
                              title: Text(
                                "Male",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
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
                              dense: true,
                              title: Text(
                                "Female",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
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
                        longitude == 0 && latitude == 0
                            ? (_isLoading
                                  ? CircularProgressIndicator()
                                  : SmallButton('Get current location', () {
                                      getLocationAsync();
                                    }, 0xff32a2c0))
                            : NowText(
                                body: 'Location obtained!',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                        SmallButton('CONTINUE', () {
                          if (submit()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    RegisterScreenMentor3(newData),
                              ),
                            );
                          }
                        }, 0xff32a2c0),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => RegisterScreenInitial(),
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
                      'SIGN UP AS COMMUNITY MENTOR',
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
