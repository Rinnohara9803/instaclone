import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/UserPosts/user_posts_page.dart';
import 'package:instaclone/presentation/pages/UserReels/user_reels_page.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:instaclone/providers/user_reels_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UserReelsGridViewWidget extends StatefulWidget {
  const UserReelsGridViewWidget({super.key});

  @override
  State<UserReelsGridViewWidget> createState() =>
      UserReelsGridViewWidgetState();
}

class UserReelsGridViewWidgetState extends State<UserReelsGridViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reel = Provider.of<ReelModel>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserReelsPage(
              reelsIndex:
                  Provider.of<ReelsProvider>(context).userReels.indexOf(reel),
            ),
          ),
        );
      },
      child: UserReelGridViewVideoWidget(
        reel: reel,
      ),
    );
  }
}

class UserReelGridViewVideoWidget extends StatefulWidget {
  final ReelModel reel;
  const UserReelGridViewVideoWidget({super.key, required this.reel});

  @override
  State<UserReelGridViewVideoWidget> createState() =>
      _UserReelGridViewVideoWidgetState();
}

class _UserReelGridViewVideoWidgetState
    extends State<UserReelGridViewVideoWidget> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.reel.video,
      ),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
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
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                VideoPlayer(_controller),
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle,
                        color: Colors.white,
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print('video error');
          print(snapshot.error);

          return Container(
            color: Colors.grey,
          );
        } else {
          print('video error');
          print('hey hey');
          return Container(
            color: Colors.grey,
          );
        }
      },
    );
  }
}
