import 'package:flutter/material.dart';

class NowHeader extends StatelessWidget {
  const NowHeader(this.text, {super.key, this.color = Colors.white});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Now',
          color: color,
          decorationThickness: 0,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
