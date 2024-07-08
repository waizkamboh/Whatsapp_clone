import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SpinKitThreeBounce(
          color: Colors.blue,
          size: 20.0,
        ),
        SizedBox(width: 10),
        Text('Typing...'),
      ],
    );
  }
}
