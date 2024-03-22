import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/animated_favorite_widget.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPostWidget extends StatefulWidget {
  final UserPostModel post;
  const VideoPostWidget({super.key, required this.post});

  @override
  State<VideoPostWidget> createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  late AnimationController _animationController;
  late Animation<double> _animation;

  late AnimationController _animationController1;
  late Animation<double> _animation1;

  bool _showFavouriteIcon = false;

  final _pageController = PageController();

  int _currentPage = 1;
  bool showPageNumbers = true;
  Timer? theTimer;

  @override
  void initState() {
    theTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        showPageNumbers = false;
      });
    });

    // final post = Provider.of<UserPostModel>(
    //   context,
    //   listen: false,
    // );

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
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.post.videos[0],
      ),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.post.id),
      child: SizedBox(
        height: widget.post.videos.length > 1 ? 400 : 450,
        width: double.infinity,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.post.videos.length,
              onPageChanged: (value) {
                _controller.dispose();
                _controller = VideoPlayerController.networkUrl(
                  Uri.parse(
                    widget.post.videos[value],
                  ),
                );
                _initializeVideoPlayerFuture = _controller.initialize();
                _controller.play();
                theTimer!.cancel();
                theTimer = Timer(const Duration(seconds: 5), () {
                  setState(() {
                    showPageNumbers = false;
                  });
                });
                setState(() {
                  _currentPage = value + 1;
                  showPageNumbers = true;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
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
                    if (widget.post.isLiked) {
                      return;
                    }
                    {
                      await widget.post.toggleIsLiked();
                    }
                  },
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: VideoPlayer(
                                        _controller,
                                      ),
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
                            ),
                          ),
                        ],
                      ),
                      if (_showFavouriteIcon)
                        AnimatedFavoriteWidget(
                          animationController1: _animationController1,
                          animation1: _animation1,
                          post: widget.post,
                        ),
                    ],
                  ),
                );
              },
            ),
            if (widget.post.videos.length > 1)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  opacity: showPageNumbers ? 1 : 0,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).isLightTheme
                            ? Colors.white
                            : Colors.black87,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child:
                          Text('$_currentPage/${widget.post.videos.length}')),
                ),
              ),
          ],
        ),
      ),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 0) {
          // Widget is not visible, pause video
          _controller.pause();
        } else {
          // Widget is visible, play video
          _controller.play();
        }
      },
    );
  }
}
