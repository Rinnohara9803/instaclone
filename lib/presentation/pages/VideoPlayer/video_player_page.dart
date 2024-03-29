import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/animated_favorite_widget.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/post_user_details.dart';
import 'package:video_player/video_player.dart';

class VideoPlayingPage extends StatefulWidget {
  final UserPostModel post;
  final String videoUrl;

  const VideoPlayingPage(this.post, this.videoUrl);

  static const String pathName = '/video-player-page';

  @override
  _VideoPlayingPageState createState() => _VideoPlayingPageState();
}

class _VideoPlayingPageState extends State<VideoPlayingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _animationController1;
  late Animation<double> _animation1;

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
          )
          ..initialize().then(
            (_) => _videoPlayerController.play(),
          );
    timerFunction();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController1.dispose();
    _videoPlayerController.dispose();
    setPortrait();
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

  Future setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future setPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  playPauseFunction() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  Future goToPosition(
    Duration Function(Duration? currentPosition) builder,
  ) async {
    final currentPosition = await _videoPlayerController.position;
    final newPosition = builder(currentPosition);

    await _videoPlayerController.seekTo(newPosition);
  }

  Future forward10Seconds() async => goToPosition(
        (currentPosition) =>
            currentPosition! +
            const Duration(
              seconds: 10,
            ),
      );
  Future rewind10Seconds() async => goToPosition(
        (currentPosition) =>
            currentPosition! -
            const Duration(
              seconds: 10,
            ),
      );

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMuted = _videoPlayerController.value.volume == 0;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _isVisible
            ? AppBar(
                backgroundColor: Colors.black.withOpacity(0.3),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    setPortrait();
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
              )
            : null,
        body: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
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
              isMuted ? 1 : 0,
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
            if (widget.post.isLiked) {
              return;
            }
            {
              await widget.post.toggleIsLiked();
            }
          },
          child: Stack(
            children: [
              _videoPlayerController.value.isInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(
                          _videoPlayerController,
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
              if (_showFavouriteIcon)
                AnimatedFavoriteWidget(
                  animationController1: _animationController1,
                  animation1: _animation1,
                  post: widget.post,
                ),
              Positioned(
                bottom: 120,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        await widget.post.toggleIsLiked();

                        // Toggle the liked state here
                        // You can update your state management accordingly
                      },
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Icon(
                              widget.post.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.post.isLiked
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      widget.post.likes.length.toString(),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      '0',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 85,
                left: 0,
                right: 0,
                child: PostUserDetails(
                  userId: widget.post.userId,
                ),
              ),
              Positioned(
                bottom: 30,
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
              Positioned(
                bottom: 40,
                right: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.fullscreen,
                      ),
                      onPressed: () {
                        if (isLandscape) {
                          setPortrait();
                        } else {
                          setLandscape();
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (_isVisible)
                Positioned(
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: IconButton(
                        iconSize: 25,
                        icon: Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                        ),
                        onPressed: () {
                          _videoPlayerController.setVolume(
                            isMuted ? 1 : 0,
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
