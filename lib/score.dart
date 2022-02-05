import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final int score;
  const Score({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Score:  ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 37,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            fontSize: 50,
          ),
        ),
      ],
    );
  }
}
