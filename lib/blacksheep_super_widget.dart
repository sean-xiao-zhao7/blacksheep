import 'package:flutter/widgets.dart';

// screens
import 'package:sheepfold/screens/home_screen.dart';
import 'package:sheepfold/screens/register/register_screen_initial.dart';

class BlacksheepSuperWidget extends StatefulWidget {
  const BlacksheepSuperWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BlacksheepSuperWidgetState();
  }
}

class _BlacksheepSuperWidgetState extends State<BlacksheepSuperWidget> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
