import 'package:flutter/material.dart';

// screens
import 'package:sheepfold/screens/home_screen.dart';

void main() {
  runApp(BlackSheepApp());
}

class BlackSheepApp extends StatelessWidget {
  const BlackSheepApp([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Scaffold(body: HomeScreen()));
  }
}
