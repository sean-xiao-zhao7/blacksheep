import 'package:flutter/material.dart';

class SmallButtonFlexible extends StatelessWidget {
  const SmallButtonFlexible({
    super.key,
    required this.text,
    required this.handler,
    this.forgroundColor = const Color(0xff32a2c0),
    this.backgroundColor = Colors.white,
  });
  final String text;
  final Function handler;
  final Color forgroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor.withAlpha(250),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      ),
      onPressed: () {
        handler();
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: forgroundColor,
          fontFamily: 'Now',
        ),
      ),
    );
  }
}
