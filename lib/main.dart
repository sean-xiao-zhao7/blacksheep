import 'package:flutter/material.dart';

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
          child: const Center(
            child: Text('Sheepfold', style: TextStyle(fontFamily: 'Genty')),
          ),
        ),
      ),
    );
  }
}
