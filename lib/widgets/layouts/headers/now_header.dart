import 'package:flutter/material.dart';

class NowHeader extends StatelessWidget {
  const NowHeader(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Now', color: Colors.white, fontSize: 32),
        textAlign: TextAlign.center,
      ),
    );
  }
}
