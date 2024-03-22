import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/presentation/pages/ChatDetails/picture_details.dart';
import 'package:instaclone/providers/chat_details_provider.dart';
import 'package:provider/provider.dart';

class ChatPicturesGridView extends StatefulWidget {
  final ChatUser user;
  const ChatPicturesGridView({super.key, required this.user});

  @override
  State<ChatPicturesGridView> createState() => _ChatPicturesGridViewState();
}

class _ChatPicturesGridViewState extends State<ChatPicturesGridView> {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ChatDetailsProvider>(context, listen: false)
            .fetchChatImages(widget.user, false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return Consumer<ChatDetailsProvider>(
                builder: (context, chatDetails, _) {
              if (chatDetails.chatImages.isEmpty) {
                return const Center(
                  child: Text('No pictures shared.'),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<ChatDetailsProvider>(context,
                            listen: false)
                        .fetchChatImages(widget.user, true);
                  },
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: chatDetails.chatImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PictureDetails(
                                imageUrl: chatDetails.chatImages[index],
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: chatDetails.chatImages[index],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => const SizedBox(
                            width: double.infinity,
                            // height: constraints.maxHeight,
                            child: Center(
                              child: Icon(
                                Icons.error,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            });
          }
        });

    // return FutureBuilder(
    //   future: fetchChatImages(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return Text(snapshot.error.toString());
    //     }
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //       case ConnectionState.none:
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       case ConnectionState.active:
    //       case ConnectionState.done:
    //         if (images.isEmpty) {
    //           return const Center(
    //             child: Text(
    //               'No pictures shared.',
    //             ),
    //           );
    //         } else {
    //           return SmartRefresher(
    //             enablePullUp: true,
    //             enablePullDown: false,
    //             controller: _refreshController,
    //             onRefresh: _onRefresh,
    //             onLoading: _onRefresh,
    //             footer: CustomFooter(
    //               builder: (BuildContext context, LoadStatus? mode) {
    //                 Widget body;
    //                 if (mode == LoadStatus.idle) {
    //                   body = const SizedBox();
    //                 } else if (mode == LoadStatus.loading) {
    //                   body = const CircularProgressIndicator();
    //                 } else if (mode == LoadStatus.failed) {
    //                   body = const Text("Load Failed!");
    //                 } else {
    //                   body = const SizedBox();
    //                 }
    //                 return SizedBox(
    //                   height: 55.0,
    //                   child: Center(
    //                     child: body,
    //                   ),
    //                 );
    //               },
    //             ),
    //             child: GridView.builder(
    //               shrinkWrap: true,
    //               physics: const BouncingScrollPhysics(),
    //               itemCount: 3,
    //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 3,
    //                 crossAxisSpacing: 2,
    //                 mainAxisSpacing: 2,
    //               ),
    //               itemBuilder: (context, index) {
    //                 return CachedNetworkImage(
    //                   fit: BoxFit.cover,
    //                   width: double.infinity,
    //                   imageUrl: images[index],
    //                   progressIndicatorBuilder:
    //                       (context, url, downloadProgress) => const Center(
    //                     child: CircularProgressIndicator(),
    //                   ),
    //                   errorWidget: (context, url, error) => SizedBox(
    //                     width: double.infinity,
    //                     // height: constraints.maxHeight,
    //                     child: const Center(
    //                       child: Icon(
    //                         Icons.error,
    //                       ),
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //           );
    //         }
    //     }
    //   },
    // );
  }
}
