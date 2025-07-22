import 'package:flutter/material.dart';
import 'package:sheepfold/widgets/buttons/main_button.dart';
import 'package:sheepfold/widgets/layouts/genty_header.dart';

void main() {
  runApp(BlackSheepApp());
}

class BlackSheepApp extends StatelessWidget {
  const BlackSheepApp([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 150, bottom: 120),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/main/blacksheep_background_full.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            spacing: 20,
            children: [
              GentyHeader('BlackSheep'),
              Spacer(),
              MainButton('Looking for connection?', () {}),
              MainButton('Mentor someone', () {}),
            ],
          ),
        ),
      ),
    );
  }
}
