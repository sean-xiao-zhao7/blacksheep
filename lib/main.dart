import 'package:flutter/material.dart';
import 'package:sheepfold/widgets/buttons/main_button.dart';
import 'package:sheepfold/widgets/layouts/genty_header.dart';

void main() {
  runApp(SheepfoldApp());
}

class SheepfoldApp extends StatelessWidget {
  const SheepfoldApp([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/main/sheepfold_background_full.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              GentyHeader('Sheepfold'),
              MainButton('Sign Up as Mentee'),
              MainButton('Sign Up as Mentor'),
            ],
          ),
        ),
      ),
    );
  }
}
