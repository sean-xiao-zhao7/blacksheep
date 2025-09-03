import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:sheepfold/screens/register/register_screen_3.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';
import 'package:sheepfold/widgets/buttons/small_button.dart';
import 'package:sheepfold/widgets/layouts/headers/now_header.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2(this.registerData, {super.key});
  final Map<String, dynamic> registerData;

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
      newData['firstName'] = _firstNameController.text;
      newData['lastName'] = _lastNameController.text;
      newData['age'] = _ageController.text;
      newData['gender'] = _genderController.text;
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
      latitude = locationData.longitude!;
      _isLoading = false;
    });
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
                top: 80,
                left: 50,
                right: 50,
                bottom: 50,
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
                        return null;
                      },
                      autocorrect: false,
                      textCapitalization: TextCapitalization.sentences,
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
                        return null;
                      },
                      autocorrect: false,
                      textCapitalization: TextCapitalization.sentences,
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
                        return null;
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            title: Text("Male"),
                            value: 'MALE',
                            groupValue: _genderController.text,
                            onChanged: (value) {
                              setState(() {
                                _genderController.text = value!;
                              });
                            },
                            activeColor: Color(0xff32a2c0),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text("Female"),
                            value: 'FEMALE',
                            groupValue: _genderController.text,
                            onChanged: (value) {
                              setState(() {
                                _genderController.text = value!;
                              });
                            },
                            activeColor: Color(0xff32a2c0),
                          ),
                        ),
                      ],
                    ),
                    longitude == 0 && latitude == 0
                        ? (_isLoading
                              ? CircularProgressIndicator()
                              : SmallButton('Get current location', () {
                                  getLocationAsync();
                                }, 0xff32a2c0))
                        : Text('Location obtained!'),
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
