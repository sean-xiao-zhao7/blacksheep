import 'package:flutter/material.dart';

class GentyHeader extends StatelessWidget {
  const GentyHeader(
    this.text, {
    super.key,
    this.fontSize = 70,
    this.color = Colors.black,
  });
  final String text;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Genty',
          color: Colors.white,
          fontSize: fontSize,
          decorationThickness: 0,
          shadows: [
            Shadow(
              blurRadius: 10.0, // shadow blur
              color: color, // shadow color
              offset: Offset(2.0, 2.0), // how much shadow will be shown
            ),
          ],
        ),
      ),
    );
  }
}
