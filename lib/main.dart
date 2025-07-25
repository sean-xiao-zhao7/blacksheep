import 'package:flutter/material.dart';

// screens
import 'package:sheepfold/blacksheep_super_widget.dart';

void main() {
  runApp(BlackSheepApp());
}

class BlackSheepApp extends StatelessWidget {
  const BlackSheepApp([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Scaffold(body: BlacksheepSuperWidget()));
  }
}
