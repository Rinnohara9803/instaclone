import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/models/comment.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/utilities/my_date_util.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat_user.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({
    super.key,
    required this.comment,
    required this.setReplyTo,
    required this.setCommentId,
    required this.replyToId,
    required this.addReply,
  });
  final Comment comment;
  final Function setReplyTo;
  final Function setCommentId;
  final String replyToId;
  final Function addReply;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future<void> fetchReplies;
  late Animation<double> _animation;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: ChatApis.getUserInfoWithUserId(widget.comment.userId),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .2),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.035,
                    width: MediaQuery.of(context).size.height * 0.035,
                    fit: BoxFit.cover,
                    imageUrl: list.isEmpty ? 'no image' : list[0].profileImage,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => const CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBoxConstants.sizedboxw5,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StreamBuilder(
                        stream: ChatApis.getUserInfoWithUserId(
                            widget.comment.userId),
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return const Text('User');
                          // } else {
                          final data = snapshot.data?.docs;
                          final list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];
                          return Text(
                            list.isEmpty ? '' : list[0].userName,
                          );
                          // }
                        },
                      ),
                      SizedBoxConstants.sizedboxw10,
                      Text(
                        MyDateUtil.getUsersStoryTime(
                          context: context,
                          time: widget.comment.createdAt.millisecondsSinceEpoch
                              .toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.comment.comment,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final user = await ChatApis.getUserInformation(
                          widget.comment.userId) as dynamic;
                      if (user == null) {
                        Toasts.showNormalSnackbar(
                            context, 'Something went wrong.');
                      } else {
                        widget.setReplyTo(user);
                        widget.setCommentId(widget.replyToId);
                      }
                    },
                    child: Text(
                      'Reply',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBoxConstants.sizedboxw5,
            Consumer<Comment>(builder: (context, comment, child) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                      await comment
                          .toggleIsLikedByMeForReplye(widget.replyToId);
                    },
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: Icon(
                            comment.isLikedByMe
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: comment.isLikedByMe ? Colors.red : null,
                            size: 18,
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    comment.likedBy.length.toString(),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
