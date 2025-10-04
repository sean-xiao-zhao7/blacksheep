import 'package:flutter/material.dart';

class LargeInfoButton extends StatelessWidget {
  const LargeInfoButton(
    this.handler, {
    super.key,
    this.size = 300,
    this.headerText = '',
    this.secondaryText = '',
  });
  final String headerText;
  final String secondaryText;
  final Function handler;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
        fixedSize: Size.fromWidth(size),
      ),
      onPressed: () {
        handler();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 43, 141, 168),
                  fontFamily: 'Now',
                ),
              ),
              Text(
                secondaryText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Now',
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_circle_right,
            size: 40,
            color: Color.fromARGB(255, 43, 141, 168),
          ),
        ],
      ),
    );
  }
}
