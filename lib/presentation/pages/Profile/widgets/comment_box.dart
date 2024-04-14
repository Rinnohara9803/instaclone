import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/models/comment.dart';
import 'package:instaclone/presentation/pages/Home/home_page.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/comment_widget.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/comments_provider.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class CommentBox extends StatefulWidget {
  const CommentBox(
      {super.key, required this.postId, required this.scrollController});

  final String postId;
  final ScrollController scrollController;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  late Future<void> fetchComments;

  @override
  void initState() {
    fetchComments = Provider.of<CommentsProvider>(context, listen: false)
        .fetchCommentsWithLimit(widget.postId, 10);
    super.initState();
  }

  final _selectedCommentNotifier = ValueNotifier<dynamic>(null);

  void setSelectedComment(Comment comment) {
    _selectedCommentNotifier.value = comment;
  }

  final _textValueNotifier = ValueNotifier('');
  final textController = TextEditingController();

  final _replyToIndividualNotifier = ValueNotifier<dynamic>(null);
  final _commentNotifier = ValueNotifier<dynamic>(null);

  void setReplyToIndividualNotifier(ChatUser user) {
    _replyToIndividualNotifier.value = user;
    textController.text = '@${user.userName} ';
  }

  void setCommentNotifier(String commentId) {
    _commentNotifier.value = commentId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxConstants.sizedboxh20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black45
                          : Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBoxConstants.sizedboxh5,
              const Center(
                child: Text(
                  'Comments',
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              Expanded(
                child: FutureBuilder(
                    future: fetchComments,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: BlueRefreshIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return Consumer<CommentsProvider>(
                            builder: (ctx, commentsData, child) {
                          if (commentsData.comments.isEmpty) {
                            return const Center(
                              child: Text(
                                'No comments.',
                              ),
                            );
                          } else {
                            return ListView.builder(
                              controller: widget.scrollController,
                              itemCount: commentsData.comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChangeNotifierProvider.value(
                                  value: commentsData.comments[index],
                                  child: CommentWidget(
                                    comment: commentsData.comments[index],
                                    setReplyTo: setReplyToIndividualNotifier,
                                    setCommentId: setCommentNotifier,
                                    scrollController: widget.scrollController,
                                  ),
                                );
                              },
                            );
                          }
                        });
                      }
                    }),
              ),
              ValueListenableBuilder(
                  valueListenable: _replyToIndividualNotifier,
                  builder: (ctx, value, child) {
                    if (value != null) {
                      final user = value as ChatUser;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                        ),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Text(
                                'Reply to ${user.userName}',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _replyToIndividualNotifier.value = null;
                                _commentNotifier.value = null;
                                textController.clear();
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
              Container(
                color: Theme.of(context).errorColor,
                height: 1,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 14,
                  top: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<ProfileProvider>(
                        builder: (context, profileData, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * .2,
                        ),
                        child: CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.045,
                          width: MediaQuery.of(context).size.height * 0.045,
                          fit: BoxFit.cover,
                          imageUrl: profileData.chatUser.profileImage.isEmpty
                              ? 'no image'
                              : profileData.chatUser.profileImage,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Icon(
                            Icons.person,
                            size: MediaQuery.of(context).size.height * 0.020,
                            color: Colors.grey,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: MediaQuery.of(context).size.height * 0.020,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        cursorColor:
                            Provider.of<ThemeProvider>(context).isLightTheme
                                ? Colors.black
                                : Colors.white,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          hintText: 'Add a comment...',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) async {
                          _textValueNotifier.value = value;
                        },
                        // inputFormatters: [
                        //   TextInputFormatter.withFunction((oldValue, newValue) {
                        //     print('text fomatting');
                        //     print(newValue.text);
                        //     print('text fomatting');
                        //     // Parse the input text using regular expression to find words starting with '@'
                        //     final matches = _pattern.allMatches(newValue.text);
                        //     print(matches.length);

                        //     // Apply custom formatting to each match
                        //     TextSpan highlightedText = TextSpan(
                        //       style: TextStyle(
                        //           color: Colors.black), // Default color for text
                        //       children: [],
                        //     );

                        //     // Loop through each match and apply highlighting
                        //     for (Match match in matches) {
                        //       // If the match starts with '@', apply red color
                        //       if (match.start == 0 ||
                        //           (match.start > 0 &&
                        //               newValue.text[match.start - 1] == ' ')) {
                        //         highlightedText.children!.add(
                        //           TextSpan(
                        //             text: match.group(0),
                        //             style: TextStyle(
                        //                 color:
                        //                     Colors.red), // Highlighted text color
                        //           ),
                        //         );
                        //       } else {
                        //         // If the match doesn't start with '@', apply default color
                        //         highlightedText.children!.add(
                        //           TextSpan(
                        //             text: match.group(0),
                        //             style: TextStyle(
                        //                 color: Colors.black), // Default text color
                        //           ),
                        //         );
                        //       }
                        //     }

                        //     // Return the updated text with highlighting
                        //     return TextEditingValue(
                        //       text: newValue.text,
                        //       selection: newValue.selection,
                        //       composing: TextRange.empty,
                        //     ).copyWith(
                        //       composing: TextRange.empty,
                        //       text: newValue.text,
                        //       selection: newValue.selection,
                        //     );
                        //   }),
                        // ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _textValueNotifier,
                      builder: (context, value, _) {
                        if (value.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            padding: const EdgeInsets.all(
                              6,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                if (_replyToIndividualNotifier.value != null) {
                                  await Provider.of<CommentsProvider>(context,
                                          listen: false)
                                      .postReplyToComment(widget.postId,
                                          _commentNotifier.value, value.trim())
                                      .then((_) {
                                    _textValueNotifier.value = '';
                                    textController.clear();
                                    _commentNotifier.value = null;
                                    _replyToIndividualNotifier.value = null;
                                  });
                                } else {
                                  await Provider.of<CommentsProvider>(context,
                                          listen: false)
                                      .postComment(widget.postId, value.trim())
                                      .then((_) {
                                    _textValueNotifier.value = '';
                                    textController.clear();
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Consumer<CommentsProvider>(builder: (context, commentsData, child) {
            if (commentsData.selectedComment == null) {
              return const SizedBox();
            } else {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.04,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1 comment selected',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.report_problem_outlined,
                              color: Colors.white,
                            ),
                          ),
                          if (commentsData.selectedComment!.userId !=
                              FirebaseAuth.instance.currentUser!.uid)
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.block_flipped,
                                color: Colors.white,
                              ),
                            ),
                          if (commentsData.selectedComment!.userId ==
                              FirebaseAuth.instance.currentUser!.uid)
                            IconButton(
                              onPressed: () {
                                commentsData.deleteComment(
                                    commentsData.selectedComment!);
                              },
                              icon: const Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                              ),
                            ),
                          IconButton(
                            onPressed: () {
                              commentsData.setSelectedComment(null);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
