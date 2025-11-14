import 'package:flutter/material.dart';

class NowText extends StatelessWidget {
  const NowText({
    super.key,
    required this.body,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 16,
  });
  final String body;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      body,
      style: TextStyle(
        fontFamily: 'Now',
        fontWeight: fontWeight,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}
