import 'package:flutter/material.dart';

class LargeInfoButton extends StatelessWidget {
  const LargeInfoButton(
    this.handler, {
    super.key,
    this.size = 300,
    this.headerText = '',
    this.secondaryText = '',
    this.secondaryTextColor = const Color.fromARGB(255, 43, 141, 168),
    this.iconType = 'message',
  });
  final String headerText;
  final String secondaryText;
  final Color secondaryTextColor;
  final Function handler;
  final double size;
  final String iconType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(20),
          fixedSize: Size.fromWidth(size),
          backgroundColor: Colors.white.withAlpha(245),
        ),
        onPressed: () {
          handler();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(
                  iconType == 'phone' ? Icons.phone : Icons.message,
                  size: 30,
                  color: Color.fromARGB(255, 43, 141, 168),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: secondaryText == ''
                      ? [
                          Text(
                            headerText,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Now',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      : [
                          Text(
                            headerText,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Now',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            secondaryText.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: secondaryTextColor,
                              fontFamily: 'Now',
                            ),
                          ),
                        ],
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
      ),
    );
  }
}
