import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/UserPosts/user_posts_page.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UserPostGridViewWidget extends StatefulWidget {
  const UserPostGridViewWidget({super.key});

  @override
  State<UserPostGridViewWidget> createState() => UserPostGridViewWidgetState();
}

class UserPostGridViewWidgetState extends State<UserPostGridViewWidget> {
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
    final post = Provider.of<UserPostModel>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserPostsPage(
                postIndex: Provider.of<UserPostsProvider>(context)
                    .userPosts
                    .indexOf(post),
              ),
            ),
          );
        },
        child: Stack(
          children: [
            if (post.medias[0].type == MediaType.image)
              CachedNetworkImage(
                fit: BoxFit.cover,
                width: double.infinity,
                height: constraints.maxHeight,
                imageUrl: post.medias[0].url,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  child: const Center(
                    child: Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ),
            if (post.medias[0].type == MediaType.video)
              UserPostGridViewVideoWidget(
                post: post,
              ),
            if (post.medias.length > 1)
              const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.copy,
                ),
              ),
          ],
        ),
      );
    });
  }
}

class UserPostGridViewVideoWidget extends StatefulWidget {
  final UserPostModel post;
  const UserPostGridViewVideoWidget({super.key, required this.post});

  @override
  State<UserPostGridViewVideoWidget> createState() =>
      _UserPostGridViewVideoWidgetState();
}

class _UserPostGridViewVideoWidgetState
    extends State<UserPostGridViewVideoWidget> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.post.medias[0].url,
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
          return VideoPlayer(
            _controller!,
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
