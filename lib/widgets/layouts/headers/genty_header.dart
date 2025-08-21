import 'package:flutter/material.dart';

class GentyHeader extends StatelessWidget {
  const GentyHeader(this.text, {super.key, this.fontSize = 70});
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Genty',
          color: Colors.white,
          fontSize: fontSize,
          shadows: [
            Shadow(
              blurRadius: 10.0, // shadow blur
              color: Colors.black, // shadow color
              offset: Offset(2.0, 2.0), // how much shadow will be shown
            ),
          ],
        ),
      ),
    );
  }
}
