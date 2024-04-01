import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/animated_favorite_widget.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/post_user_details.dart';
import 'package:instaclone/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoDetails extends StatefulWidget {
  final ReelModel reel;
  final String videoUrl;

  const VideoDetails(this.reel, this.videoUrl, {super.key});

  static const String pathName = '/video-player-page';

  @override
  _VideoDetailsState createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _animationController1;
  late Animation<double> _animation1;

  Future<void>? _initializeVideoPlayerFuture;
  late VideoPlayerController _videoPlayerController;
  late Timer timer;
  bool _showFavouriteIcon = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController1 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 3, end: 4).animate(
      CurvedAnimation(
        parent: _animationController1,
        curve: Curves.easeOut,
      ),
    );
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..addListener(() => setState(() {}))
          ..setLooping(
            true,
          );
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setVolume(
      Provider.of<VideoPlayerProvider>(context, listen: false).isMuted ? 0 : 1,
    );

    timerFunction();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController1.dispose();
    _videoPlayerController.dispose();
    _videoPlayerController.pause();
    super.dispose();
  }

  timerFunction() {
    timer = Timer(
        const Duration(
          seconds: 5,
        ), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  playPauseFunction() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(builder: (context, videoData, _) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          videoData.setIsMuted();
          _videoPlayerController.setVolume(
            videoData.isMuted ? 0 : 1,
          );
          timer.cancel();
          setState(() {
            _isVisible = true;
            timer = Timer(
                const Duration(
                  seconds: 5,
                ), () {
              setState(() {
                _isVisible = false;
              });
            });
          });
          _videoPlayerController.setVolume(
            Provider.of<VideoPlayerProvider>(context, listen: false).isMuted
                ? 0
                : 1,
          );
        },
        onDoubleTap: () async {
          setState(() {
            _showFavouriteIcon = true;
          });
          _animationController1
              .forward()
              .then((value) => _animationController1.reverse());
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() {
              _showFavouriteIcon = false;
            });
          });
          if (widget.reel.isLiked) {
            return;
          }
          {
            await widget.reel.toggleIsLiked();
          }
        },
        child: Stack(
          children: [
            Consumer<VideoPlayerProvider>(builder: (context, videoData, _) {
              return VisibilityDetector(
                key: Key(widget.reel.id),
                onVisibilityChanged: (visibilityInfo) {
                  if (visibilityInfo.visibleFraction == 0) {
                    _videoPlayerController.pause();
                    // Widget is visible, play video
                  } else {
                    _videoPlayerController.play();
                  }
                },
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return VideoPlayer(
                        _videoPlayerController,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      );
                    }
                  },
                ),
              );
            }),
            if (_showFavouriteIcon)
              AnimatedFavoriteWidgetForReel(
                animationController1: _animationController1,
                animation1: _animation1,
                reel: widget.reel,
              ),
            Positioned(
              bottom: 55,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                      await widget.reel.toggleIsLiked();

                      // Toggle the liked state here
                      // You can update your state management accordingly
                    },
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: Icon(
                            widget.reel.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.reel.isLiked
                                ? Colors.red
                                : Theme.of(context).errorColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    widget.reel.likes.length.toString(),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mode_comment_outlined,
                    ),
                  ),
                  const Text(
                    '0',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 23,
              left: 0,
              right: 0,
              child: ReelUserDetails(
                userId: widget.reel.userId,
              ),
            ),
            Positioned(
              bottom: 1,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () {},
                child: VideoProgressIndicator(
                  _videoPlayerController,
                  allowScrubbing: true,
                ),
              ),
            ),
            if (_isVisible)
              Consumer<VideoPlayerProvider>(builder: (context, videoData, _) {
                return Positioned(
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        iconSize: 25,
                        icon: Icon(
                          videoData.isMuted
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          videoData.setIsMuted();
                          _videoPlayerController.setVolume(
                            videoData.isMuted ? 1 : 0,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}
