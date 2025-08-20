import 'package:flutter/material.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// screens
import 'package:sheepfold/blacksheep_super_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BlackSheepApp());
}

class BlackSheepApp extends StatelessWidget {
  const BlackSheepApp([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Scaffold(body: BlacksheepSuperWidget()));
  }
}
