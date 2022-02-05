import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final List<String> cityNames;
  const Question({Key? key, required this.cityNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Is ' + cityNames[0] + ' hotter or colder than ' + cityNames[1] + '?',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
        letterSpacing: 0.5,
        fontSize: 40,
      ),
    );
  }
}
