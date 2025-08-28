import 'package:flutter/material.dart';

class NowHeader extends StatelessWidget {
  const NowHeader(
    this.text, {
    super.key,
    this.color = Colors.white,
    this.fontSize = 26,
  });
  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Now',
          color: color,
          decorationThickness: 0,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
