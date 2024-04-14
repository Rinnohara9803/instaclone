import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/edit_profile_row.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/open_settings_widget.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/profile_data_widget.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_post_grid_video_widget.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_posts_grid_view.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_reels_grid_view.dart';
import 'package:instaclone/presentation/pages/UserPosts/widgets/post_user_details.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/post_details_popop_provider.dart';
import 'package:instaclone/providers/profile_data_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../apis/chat_apis.dart';
import '../../../apis/user_apis.dart';
import '../../../models/chat_user.dart';
import '../../../services/sound_recorder.dart';
import '../../resources/constants/sizedbox_constants.dart';
import '../Chat/chat_page.dart';
import '../Dashboard/widgets/custom_popup_menubutton.dart';
import '../UserPosts/user_posts_page.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser chatUser;
  final Function navigateBack;
  const ProfilePage({
    super.key,
    required this.chatUser,
    required this.navigateBack,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  late bool haveFollowed;

  List<String> list = [];

  late Stream getUserInfo;

  @override
  void initState() {
    getUserInfo = ChatApis.getUserInfo(widget.chatUser.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.chatUser.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(),
                            ),
                            const CustomPopUpMenuButton(),
                          ],
                        ),
                        if (widget.chatUser.userId != user!.uid)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notification_add,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                              ),
                            ],
                          ),
                        if (widget.chatUser.userId == user.uid)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_box_outlined,
                                ),
                              ),
                              const OpenSettingsWidget(),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: getUserInfo,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            List<ChatUser> users = [];
                            if (snapshot.hasData) {
                              for (var i in snapshot.data!.docs) {
                                users.add(ChatUser.fromJson(i.data()));
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: users[0].profileImage.isEmpty
                                              ? const CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 245, 242, 242),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: Colors.grey,
                                                  backgroundImage: NetworkImage(
                                                      users[0].profileImage),
                                                ),
                                        ),
                                      ),
                                      FutureBuilder(
                                          future:
                                              Provider.of<UserPostsProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetchAllPostsOfUser(
                                                      widget.chatUser.userId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return ProfileDataWidget(
                                                data: 0,
                                                label: 'Posts',
                                                onTap: () {},
                                              );
                                            }
                                            return Consumer<UserPostsProvider>(
                                                builder:
                                                    (context, postData, child) {
                                              return ProfileDataWidget(
                                                  data: postData
                                                      .allUserPosts.length,
                                                  label: 'Posts',
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const UserPostsPage(
                                                          postIndex: 0,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          }),
                                      FutureBuilder(
                                        future:
                                            Provider.of<ProfileDataProvider>(
                                          context,
                                          listen: false,
                                        ).getFollowers(widget.chatUser.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return ProfileDataWidget(
                                              data: 0,
                                              label: 'Followers',
                                              onTap: () {},
                                            );
                                          }

                                          return Consumer<ProfileDataProvider>(
                                              builder:
                                                  (context, ffpData, child) {
                                            return ProfileDataWidget(
                                              data: ffpData.followers,
                                              label: 'Followers',
                                              onTap: () {},
                                            );
                                          });
                                        },
                                      ),
                                      FutureBuilder(
                                        future:
                                            Provider.of<ProfileDataProvider>(
                                          context,
                                          listen: false,
                                        ).getFollowings(widget.chatUser.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return ProfileDataWidget(
                                              data: 0,
                                              label: 'Followings',
                                              onTap: () {},
                                            );
                                          }

                                          return Consumer<ProfileDataProvider>(
                                              builder:
                                                  (context, ffpData, child) {
                                            return ProfileDataWidget(
                                              data: ffpData.followings,
                                              label: 'Followings',
                                              onTap: () {},
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    users[0].userName,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    users[0].bio,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBoxConstants.sizedboxh20,
                                  if (widget.chatUser.userId == user.uid)
                                    const EditProfileRow(),
                                  if (widget.chatUser.userId != user.uid)
                                    StreamBuilder(
                                      stream:
                                          UserApis.getAllFollowings(user.uid),
                                      builder: (context, snapshot) {
                                        final data = snapshot.data?.docs;
                                        list = [];
                                        if (snapshot.hasData) {
                                          for (var i in data!) {
                                            list.add(i.data()['userId']);
                                          }
                                        }

                                        if (list.isNotEmpty) {
                                          haveFollowed = list
                                              .contains(widget.chatUser.userId);
                                        } else {
                                          haveFollowed = false;
                                        }

                                        return Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if (!haveFollowed) {
                                                    Provider.of<
                                                        ProfileDataProvider>(
                                                      context,
                                                      listen: false,
                                                    ).follow(widget.chatUser);
                                                  } else {
                                                    Provider.of<ProfileDataProvider>(
                                                            context,
                                                            listen: false)
                                                        .unfollow(
                                                            widget.chatUser);
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Provider.of<ThemeProvider>(
                                                                    context)
                                                                .isLightTheme
                                                            ? Colors.black26
                                                            : Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      !haveFollowed
                                                          ? 'Follow'
                                                          : 'Unfollow',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: !haveFollowed
                                                  ? const SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) => ChangeNotifierProvider<
                                                                    AudioProvider>(
                                                                create: (context) =>
                                                                    AudioProvider(),
                                                                child: ChatPage(
                                                                    user: widget
                                                                        .chatUser)),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .isLightTheme
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                          color: Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .isLightTheme
                                                              ? Colors.white
                                                              : const Color
                                                                  .fromARGB(255,
                                                                  48, 47, 47),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10,
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Message',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  SizedBoxConstants.sizedboxh10,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TabBar(
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          indicatorWeight: 2,
                                          indicatorColor: Theme.of(context)
                                              .tabBarTheme
                                              .indicatorColor,
                                          labelStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          tabs: const [
                                            Tab(
                                              icon: Icon(
                                                Icons.grid_on_sharp,
                                              ),
                                            ),
                                            Tab(
                                              icon: Icon(
                                                Icons.video_library_outlined,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            children: [
                                              UserPostsGridView(
                                                userId: widget.chatUser.userId,
                                              ),
                                              UserReelsGridView(
                                                  userId:
                                                      widget.chatUser.userId),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Center(
                child: Consumer<PostDetailsPopDialogProvider>(
                  builder: (ctx, data, child) {
                    if (data.showDialog == false) {
                      return const SizedBox();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Provider.of<PostDetailsPopDialogProvider>(context,
                                  listen: false)
                              .setShowDialog();
                        },
                        child: Container(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black45
                                  : Colors.white54,
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                        ),
                      );
                    }
                  },
                ),
              ),
              const Center(
                child: PostDetailsPopUp(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostDetailsPopUp extends StatelessWidget {
  const PostDetailsPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailsPopDialogProvider>(builder: (ctx, data, child) {
      if (data.showDialog == false) {
        return const SizedBox();
      } else {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              PostUserDetails(userId: data.userId!),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  child: Stack(
                    children: [
                      if (data.selectedPost!.medias[0].type == MediaType.image)
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: data.selectedPost!.medias[0].url,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey,
                            width: double.infinity,
                            child: const Center(
                              child: Icon(
                                Icons.error,
                              ),
                            ),
                          ),
                        ),
                      if (data.selectedPost!.medias[0].type == MediaType.video)
                        UserPostVideoPopOP(
                          post: data.selectedPost!,
                        ),
                      Positioned(
                          bottom: 10,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (data.isFavoriteButtonGestured)
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                      ),
                                      child: const Text(
                                        'Favorite',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (!data.isFavoriteButtonGestured)
                                const Expanded(
                                  child: SizedBox(),
                                ),
                              if (data.isCommentButtonGestured)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  child: const Text(
                                    'Comment',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (!data.isCommentButtonGestured)
                                const Expanded(
                                  child: SizedBox(),
                                ),
                              if (data.isSendButtonGestured)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (!data.isSendButtonGestured)
                                const Expanded(
                                  child: SizedBox(),
                                ),
                              if (data.isMenuButtonGestured)
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                      ),
                                      child: const Text(
                                        'Menu',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (!data.isMenuButtonGestured)
                                const Expanded(
                                  child: SizedBox(),
                                ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      data.selectedPost!.isLiked
                          ? Icons.favorite
                          : Icons.favorite_outline_outlined,
                      key: data.favoriteIconButtonKey,
                      color: data.selectedPost!.isLiked
                          ? Colors.red
                          : Theme.of(context).errorColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.comment_outlined,
                      key: data.commentIconButtonKey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send_outlined,
                      key: data.sendIconButtonKey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      key: data.menuIconButtonKey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}

class UserPostVideoPopOP extends StatefulWidget {
  final UserPostModel post;
  const UserPostVideoPopOP({super.key, required this.post});

  @override
  State<UserPostVideoPopOP> createState() => _UserPostVideoPopOPState();
}

class _UserPostVideoPopOPState extends State<UserPostVideoPopOP> {
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
    _controller.setLooping(true);
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
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
            child: VideoPlayer(
              _controller,
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            color: Colors.grey,
            child: const Center(
              child: Icon(
                Icons.error,
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.grey,
          );
        }
      },
    );
  }
}
