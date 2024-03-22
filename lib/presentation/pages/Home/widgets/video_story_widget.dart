import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../home_page.dart';

class VideoStoryWidget extends StatefulWidget {
  final VideoStory videoStory;

  const VideoStoryWidget({super.key, required this.videoStory});

  @override
  State<VideoStoryWidget> createState() => _VideoStoryWidgetState();
}

class _VideoStoryWidgetState extends State<VideoStoryWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoStory.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
