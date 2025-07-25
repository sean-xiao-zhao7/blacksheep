import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  const SmallButton(this.text, this.handler, this.color, {super.key});
  final String text;
  final Function handler;
  final int color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(color),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
        fixedSize: Size.fromWidth(300),
      ),
      onPressed: () {
        handler();
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Now',
        ),
      ),
    );
  }
}
