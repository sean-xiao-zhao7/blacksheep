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
      ),
      onPressed: () {
        handler();
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontFamily: 'Now',
          ),
        ),
      ),
    );
  }
}
