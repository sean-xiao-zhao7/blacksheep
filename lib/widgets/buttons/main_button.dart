import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(this.text, this.handler, {super.key});
  final String text;
  final Function handler;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      onPressed: () {
        handler();
      },
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Now',
          ),
        ),
      ),
    );
  }
}
