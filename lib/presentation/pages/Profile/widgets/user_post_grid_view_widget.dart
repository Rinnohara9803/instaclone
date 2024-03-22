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
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    final post = Provider.of<UserPostModel>(
      context,
      listen: false,
    );

    if (post.videos.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          post.videos[0],
        ),
      );
      _initializeVideoPlayerFuture = _controller!.initialize();
    }

    super.initState();
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
            if (post.images.isNotEmpty)
              CachedNetworkImage(
                fit: BoxFit.cover,
                width: double.infinity,
                height: constraints.maxHeight,
                imageUrl: post.images[0].imageUrl,
                // colorBlendMode: ColorFilters.colorFilterModels
                //   .firstWhere((element) =>
                //       element.filterName == post.images[0].filterName)
                //   .colorFilter,
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
            if (post.images.isNotEmpty && post.images.length != 1)
              const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.copy,
                ),
              ),
            if (post.videos.isNotEmpty)
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return VideoPlayer(
                      _controller!,
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      color: Colors.grey,
                    );
                  } else {
                    return Container(
                      color: Colors.grey,
                    );
                  }
                },
              ),
            if (post.videos.isNotEmpty && post.videos.length != 1)
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
