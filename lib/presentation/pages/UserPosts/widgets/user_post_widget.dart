import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/post_user_details.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/video_post_widget.dart';
import 'package:instaclone/utilities/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../apis/chat_apis.dart';
import '../../../../models/chat_user.dart';
import '../../../../models/user_post.dart';
import '../../../resources/themes_manager.dart';
import 'animated_favorite_widget.dart';
import 'expandable_text_widget.dart';

class UserPostWidget extends StatefulWidget {
  const UserPostWidget({
    super.key,
  });

  @override
  State<UserPostWidget> createState() => _UserPostWidgetState();
}

class _UserPostWidgetState extends State<UserPostWidget>
    with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController1.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<UserPostModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PostUserDetails(userId: post.userId),
              const Icon(
                Icons.more_vert,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          if (post.medias.isNotEmpty)
            SizedBox(
              height: post.medias.length > 1 ? 450 : 550,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: post.medias.length,
                    onPageChanged: (value) {
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
                          if (post.isLiked) {
                            return;
                          }
                          {
                            await post.toggleIsLiked();
                          }
                        },
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (post.medias[index].type == MediaType.image)
                                  CachedNetworkImage(
                                    height: post.medias.length > 1 ? 450 : 550,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    // colorBlendMode: ColorFilters.colorFilterModels
                                    //     .firstWhere((element) =>
                                    //         element.filterName ==
                                    //         post.images[index].filterName)
                                    //     .colorFilter,
                                    imageUrl: post.medias[index].url,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      height:
                                          post.medias.length > 1 ? 400 : 550,
                                      width: double.infinity,
                                      color: Colors.grey,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        SizedBox(
                                      height:
                                          post.medias.length > 1 ? 400 : 550,
                                      width: double.infinity,
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (post.medias[index].type == MediaType.video)
                                  SizedBox(
                                    height: post.medias.length > 1 ? 450 : 550,
                                    width: double.infinity,
                                    child: VideoPostWidget(
                                      post: post,
                                      videoUrl: post.medias[index].url,
                                    ),
                                  ),
                              ],
                            ),
                            if (_showFavouriteIcon)
                              AnimatedFavoriteWidget(
                                animationController1: _animationController1,
                                animation1: _animation1,
                                post: post,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (post.medias.length > 1)
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
                              color: Provider.of<ThemeProvider>(context)
                                      .isLightTheme
                                  ? Colors.white
                                  : Colors.black87,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Text('$_currentPage/${post.medias.length}')),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        await post.toggleIsLiked();

                        // Toggle the liked state here
                        // You can update your state management accordingly
                      },
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Icon(
                              post.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.isLiked ? Colors.red : null,
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        Icons.messenger_outline_sharp,
                      ),
                    ),
                  ],
                ),
                if (post.medias.length > 1)
                  SmoothPageIndicator(
                      controller: _pageController,
                      count: post.medias.length,
                      effect: const ScrollingDotsEffect(
                        dotHeight: 5,
                        dotWidth: 5,
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                        );
                      }),
                IconButton(
                  onPressed: () async {
                    await post.toggleIsBookmarked();
                  },
                  icon: Icon(
                    post.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_add_outlined,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              '${post.likes.length} likes',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: StreamBuilder(
                stream: ChatApis.getUserInfoWithUserId(post.userId),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  return ExpandableTextWidget(
                    username:
                        list.isEmpty ? 'username ' : '${list[0].userName} ',
                    caption: post.caption,
                  );
                },
              ),
            ),

          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              MyDateUtil.getUsersPostTime(
                context: context,
                time: post.id,
              ),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
