import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ConfirmVideoScreen extends StatefulWidget {
  final File video;
  final Function onConfirm;

  const ConfirmVideoScreen({Key? key, required this.video, required this.onConfirm}) : super(key: key);

  @override
  _ConfirmVideoScreenState createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends State<ConfirmVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Video'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : const CircularProgressIndicator(),
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
                  widget.onConfirm();
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
