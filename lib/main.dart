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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xA7DDCF00)],
            ),
          ),
          child: const Center(child: Text('Sheepfold')),
        ),
      ),
    );
  }
}
