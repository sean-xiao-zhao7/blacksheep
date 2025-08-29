import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(this.text, this.handler, {super.key, this.size = 300});
  final String text;
  final Function handler;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amberAccent,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
        fixedSize: Size.fromWidth(size),
      ),
      onPressed: () {
        handler();
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Now',
        ),
      ),
    );
  }
}
