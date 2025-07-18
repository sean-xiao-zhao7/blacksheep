import 'package:flutter/material.dart';

class GentyHeader extends StatelessWidget {
  const GentyHeader(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Genty',
          color: Colors.white,
          fontSize: 82,
        ),
      ),
    );
  }
}
