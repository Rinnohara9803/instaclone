import 'package:flutter/material.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/Home/home_page.dart';
import 'package:instaclone/presentation/pages/VideoPlayer/video_player_page.dart';
import 'package:instaclone/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPostWidget extends StatefulWidget {
  final UserPostModel post;
  final String videoUrl;
  const VideoPostWidget(
      {super.key, required this.post, required this.videoUrl});

  @override
  State<VideoPostWidget> createState() => VideoPostWidgetState();
}

class VideoPostWidgetState extends State<VideoPostWidget> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
    );
    _initializeVideoPlayerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller!.pause();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cts) {
      return Stack(
        children: [
          SizedBox(
            // height: cts.maxHeight,
            // width: cts.maxWidth,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoPlayingPage(widget.post, widget.videoUrl),
                  ),
                );
              },
              child: Consumer<VideoPlayerProvider>(
                builder: (context, videoData, child) {
                  return VisibilityDetector(
                    key: Key(widget.post.id),
                    onVisibilityChanged: (visibilityInfo) {
                      if (visibilityInfo.visibleFraction == 0) {
                        _controller!.pause();
                      } else {
                        _controller!.setVolume(videoData.isMuted ? 0 : 1);
                        // Widget is visible, play video
                        _controller!.play();
                      }
                    },
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: BlueRefreshIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            color: Colors.grey,
                          );
                        } else {
                          return Center(
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(
                                _controller!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Consumer<VideoPlayerProvider>(builder: (context, videoData, _) {
            return Positioned(
              bottom: 2,
              right: 2,
              child: IconButton(
                iconSize: 25,
                icon: Icon(
                  videoData.isMuted ? Icons.volume_off : Icons.volume_up,
                ),
                onPressed: () {
                  videoData.setIsMuted();
                  _controller!.setVolume(
                    videoData.isMuted ? 0 : 1,
                  );
                },
              ),
            );
          })
        ],
      );
    });
  }
}
