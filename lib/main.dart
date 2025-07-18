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
            gradient: LinearGradient(colors: [Colors.lightBlue, Colors.white]),
          ),
          child: const Center(child: Text('Sheepfold')),
        ),
      ),
    );
  }
}
