import 'package:flutter/material.dart';

class AnswerButtons extends StatelessWidget {
  final VoidCallback isHotter;
  final VoidCallback isColder;

  const AnswerButtons(
      {Key? key, required this.isHotter, required this.isColder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(
                double.infinity,
                235,
              ), // TODO: height should be % of screen?
              // maximumSize: const Size(double.infinity, 1235),
              // minimumSize: const Size(double.infinity, 235),
              // padding: const EdgeInsets.only(top: 80, bottom: 80),
              primary: const Color(0xFFDD3434),
              onPrimary: Colors.black87,
              textStyle: const TextStyle(fontSize: 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  bottomLeft: Radius.circular(35),
                ),
              ),
            ),
            onPressed: isHotter,
            child: const Icon(
              Icons.keyboard_arrow_up,
              size: 80,
              color: Colors.black54,
            ),
          ),
        ),
        const VerticalDivider(width: 13.0),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(
                double.infinity,
                235,
              ), // TODO: height should be % of screen?
              primary: const Color(0xFF1F94DE),
              onPrimary: Colors.black,
              textStyle: const TextStyle(fontSize: 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
            ),
            onPressed: isColder,
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 80,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
