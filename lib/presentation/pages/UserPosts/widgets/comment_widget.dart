import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/models/comment.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/reply_widget.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/comments_provider.dart';
import 'package:instaclone/utilities/my_date_util.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat_user.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.setReplyTo,
    required this.setCommentId,
    required this.scrollController,
  });
  final Comment comment;
  final Function setReplyTo;
  final Function setCommentId;
  final ScrollController scrollController;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
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
    fetchReplies = fetchTheReplies();
    super.initState();
  }

  final ValueNotifier _replyList = ValueNotifier<List<Comment>>([]);
  final ValueNotifier _showReplies = ValueNotifier<bool>(false);

  final firestore = FirebaseFirestore.instance;

  void addReply(Comment reply) {
    _replyList.value = [reply, ..._replyList.value];
  }

  Future<void> fetchTheReplies() async {
    try {
      List<Comment> listOfComments = [];
      await firestore
          .collection(
              'comments/${widget.comment.postId}/postComments/${widget.comment.id}/replies')
          .orderBy('id', descending: true)
          .get()
          .then((data) {
        if (data.docs.isEmpty) {
          _replyList.value = [];
        } else {
          for (var i in data.docs) {
            listOfComments.add(
              Comment.fromJson(
                i.data(),
              ),
            );
          }
          _replyList.value = listOfComments;
        }
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Provider.of<CommentsProvider>(context, listen: false)
            .setSelectedComment(widget.comment);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream:
                          ChatApis.getUserInfoWithUserId(widget.comment.userId),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        final list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * .2),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.height * 0.04,
                            fit: BoxFit.cover,
                            imageUrl: list.isEmpty
                                ? 'no image'
                                : list[0].profileImage,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
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
                                          ?.map((e) =>
                                              ChatUser.fromJson(e.data()))
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
                                  time: widget
                                      .comment.createdAt.millisecondsSinceEpoch
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
                              await comment.toggleIsLikedByMe();
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
                                    color:
                                        comment.isLikedByMe ? Colors.red : null,
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
                const SizedBox(
                  height: 3,
                ),
                GestureDetector(
                  onTap: () async {
                    final user =
                        await ChatApis.getUserInformation(widget.comment.userId)
                            as dynamic;
                    if (user == null) {
                      Toasts.showNormalSnackbar(
                          context, 'Something went wrong.');
                    } else {
                      widget.setReplyTo(user);
                      widget.setCommentId(widget.comment.id);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Text(
                      'Reply',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _showReplies,
                  builder: (ctx, value, _) {
                    if (value == false) {
                      return const SizedBox();
                    } else {
                      return ValueListenableBuilder(
                          valueListenable: _replyList,
                          builder: (context, replyList, child) {
                            final theReplyList = replyList as List<Comment>;
                            return Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ListView.builder(
                                  controller: ScrollController(),
                                  shrinkWrap: true,
                                  itemCount: replyList.length,
                                  itemBuilder: (ctx, index) {
                                    // return Text('here');
                                    return ChangeNotifierProvider.value(
                                      value: theReplyList[index],
                                      child: ReplyWidget(
                                        replyToId: widget.comment.id,
                                        comment: theReplyList[index],
                                        setReplyTo: widget.setReplyTo,
                                        setCommentId: widget.setCommentId,
                                        addReply: addReply,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    }
                  },
                ),
                FutureBuilder(
                  future: fetchReplies,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ValueListenableBuilder(
                          valueListenable: _replyList,
                          builder: (ctx, listValue, child) {
                            if (listValue.isEmpty) {
                              return const SizedBox();
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.1,
                                ),
                                child: Column(
                                  children: [
                                    SizedBoxConstants.sizedboxh5,
                                    GestureDetector(
                                      onTap: () {
                                        _showReplies.value =
                                            !_showReplies.value;
                                      },
                                      child: ValueListenableBuilder(
                                          valueListenable: _showReplies,
                                          builder: (context, value, child) {
                                            if (value == true) {
                                              return Text(
                                                'Hide all replies',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                    ),
                                              );
                                            } else {
                                              return Text(
                                                'View (${listValue.length}) replies',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                    ),
                                              );
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          Consumer<CommentsProvider>(builder: (context, commentsData, child) {
            if (commentsData.selectedComment != null &&
                commentsData.selectedComment!.id == widget.comment.id) {
              return Positioned.fill(
                child: Center(
                  child: Container(
                    color: Provider.of<ThemeProvider>(context).isLightTheme
                        ? Colors.black12
                        : Colors.white24,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }
}
