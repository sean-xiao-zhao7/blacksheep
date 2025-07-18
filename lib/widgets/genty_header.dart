import 'package:flutter/material.dart';

class GentyHeader extends StatelessWidget {
  const GentyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Sheepfold',
        style: TextStyle(
          fontFamily: 'Genty',
          color: Colors.white,
          fontSize: 82,
        ),
      ),
    );
  }
}
