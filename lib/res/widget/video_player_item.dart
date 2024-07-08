import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerPlusController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: {
        'Connection': 'keep-alive',
      },
      invalidateCacheIfOlderThan: const Duration(minutes: 10),
    )..initialize().then((value) async {
      await videoPlayerController.setLooping(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized
        ? Center(
      child: AspectRatio(
        aspectRatio: 16/16,
        child: Stack(
          children: [
            CachedVideoPlayerPlus(videoPlayerController),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  if (isPlay) {
                    videoPlayerController.pause();
                  } else {
                    videoPlayerController.play();
                  }

                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                icon: Icon(
                  isPlay ? Icons.pause_circle : Icons.play_circle,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
