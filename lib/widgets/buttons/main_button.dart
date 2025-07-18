import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text(text));
  }
}
