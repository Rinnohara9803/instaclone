import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_post_grid_video_widget.dart';
import 'package:instaclone/presentation/pages/UserPosts/user_posts_page.dart';
import 'package:instaclone/providers/post_details_popop_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';

class UserPostGridViewWidget extends StatefulWidget {
  const UserPostGridViewWidget({super.key});

  @override
  State<UserPostGridViewWidget> createState() => UserPostGridViewWidgetState();
}

class UserPostGridViewWidgetState extends State<UserPostGridViewWidget> {
  AudioPlayer? player;

  Future<void> setAudio() async {
    player = AudioPlayer();
  }

  @override
  void initState() {
    setAudio();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool areOffsetsNear(
      Offset offset1, Offset offset2, double distanceThreshold) {
    // Calculate the differences in x and y coordinates
    double dx = offset1.dx - offset2.dx;
    double dy = offset1.dy - offset2.dy;

    // Check if the distance in the right direction (dx) and bottom direction (dy) is less than or equal to the threshold
    return dx >= 0 &&
        dy >= 0 &&
        dx <= distanceThreshold &&
        dy <= distanceThreshold;
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<UserPostModel>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<PostDetailsPopDialogProvider>(
          builder: (context, data, child) {
        return GestureDetector(
          onLongPress: () async {
            data.setSelectedPost(post);
            data.setShowDialog();
          },
          onLongPressEnd: (updateDetails) {
            data.accessButtonPositions();
            // Get the comment icon button position
            final commentIconButtonPosition = data.commentIconButtonKeyPosition;
            final favoriteIconButtonPosition =
                data.favoriteIconButtonKeyPosition;
            final sendIconButtonPosition = data.sendIconButtonKeyPosition;
            final menuIconButtonPosition = data.menuIconButtonKeyPosition;

            // Get the current global position of the gesture
            final currentGlobalPosition = updateDetails.globalPosition;

            // Check if the current global position is near the comment icon button position
            final bool isNearCommentIconButton = areOffsetsNear(
              currentGlobalPosition,
              commentIconButtonPosition,
              25,
            );

            final bool isNearFavoriteIconButton = areOffsetsNear(
              currentGlobalPosition,
              favoriteIconButtonPosition,
              25,
            );
            final bool isNearSendIconButton = areOffsetsNear(
              currentGlobalPosition,
              sendIconButtonPosition,
              25,
            );
            final bool isNearMenuIconButton = areOffsetsNear(
              currentGlobalPosition,
              menuIconButtonPosition,
              25,
            );

            // Print the result
            if (isNearCommentIconButton) {
            } else if (isNearFavoriteIconButton) {
              data.selectedPost!.toggleIsLiked();
            } else if (isNearSendIconButton) {
              Toasts.showNormalSnackbar(context, 'On Send icons');
            } else if (isNearMenuIconButton) {
              Toasts.showNormalSnackbar(context, 'On Menu Icon');
            } else {
              Toasts.showNormalSnackbar(context, 'No on anything');
            }
            data.setShowDialog();
          },
          onLongPressMoveUpdate: (updateDetails) async {
            data.accessButtonPositions();
            // Get the comment icon button position
            final commentIconButtonPosition = data.commentIconButtonKeyPosition;
            final favoriteIconButtonPosition =
                data.favoriteIconButtonKeyPosition;
            final sendIconButtonPosition = data.sendIconButtonKeyPosition;
            final menuIconButtonPosition = data.menuIconButtonKeyPosition;

            // Get the current global position of the gesture
            final currentGlobalPosition = updateDetails.globalPosition;

            // Check if the current global position is near the comment icon button position
            final bool isNearCommentIconButton = areOffsetsNear(
              currentGlobalPosition,
              commentIconButtonPosition,
              25,
            );

            final bool isNearFavoriteIconButton = areOffsetsNear(
              currentGlobalPosition,
              favoriteIconButtonPosition,
              25,
            );
            final bool isNearSendIconButton = areOffsetsNear(
              currentGlobalPosition,
              sendIconButtonPosition,
              25,
            );
            final bool isNearMenuIconButton = areOffsetsNear(
              currentGlobalPosition,
              menuIconButtonPosition,
              25,
            );

            // Print the result
            if (isNearCommentIconButton) {
              Provider.of<PostDetailsPopDialogProvider>(context, listen: false)
                  .setIsCommentButtonGestured(true);
            } else if (isNearFavoriteIconButton) {
              Provider.of<PostDetailsPopDialogProvider>(context, listen: false)
                  .setIsFavoriteButtonGestured(true);
            } else if (isNearSendIconButton) {
              Provider.of<PostDetailsPopDialogProvider>(context, listen: false)
                  .setIsSendButtonGestured(true);
            } else if (isNearMenuIconButton) {
              Provider.of<PostDetailsPopDialogProvider>(context, listen: false)
                  .setIsMenuButtonGestured(true);
            } else {
              Provider.of<PostDetailsPopDialogProvider>(context, listen: false)
                  .setGesturedTofalse();
            }
          },
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
    });
  }
}
