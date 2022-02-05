import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final List<String> cityNames;
  const Question({Key? key, required this.cityNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            fontSize: 39,
          ),
          children: <TextSpan>[
            const TextSpan(
              text: 'Is ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: cityNames[0],
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
            const TextSpan(
              text: ' hotter or colder than ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: cityNames[1],
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
            const TextSpan(
              text: '?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
