import 'package:flutter/material.dart';

class FBW extends StatelessWidget {
  final Function getData;
  const FBW({Key? key, required this.getData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // ... some code here

        // Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: getData(),
    );
  }
}
