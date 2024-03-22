import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instaclone/models/video_file_model.dart';
import 'package:video_player/video_player.dart';

class VideoItemWidget extends StatefulWidget {
  final bool isSelected;
  final Files videoFile;
  const VideoItemWidget(
      {Key? key, required this.videoFile, required this.isSelected})
      : super(key: key);

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  VideoPlayerController? _controller;
  // Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(
      File(widget.videoFile.path),
    );
    _controller!.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    int milliseconds = int.parse(widget.videoFile.duration);
    Duration duration = Duration(milliseconds: milliseconds);

    String formattedTime = formatDuration(duration);

    return Container(
      color: Colors.grey,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          Positioned(
            bottom: 2,
            right: 2,
            child: Text(
              formattedTime.toString(),
            ),
          ),
          if (widget.isSelected)
            Center(
              child: Container(
                color: widget.isSelected
                    ? Colors.black.withOpacity(0.6)
                    : Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
