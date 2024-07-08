import 'dart:io';
import 'package:flutter/material.dart';

class ConfirmImageScreen extends StatelessWidget {
  final File image;
  final Function onConfirm;

  const ConfirmImageScreen({super.key, required this.image, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(image),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
