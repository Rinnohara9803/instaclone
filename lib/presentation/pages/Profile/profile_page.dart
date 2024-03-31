import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/open_settings_widget.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/profile_data_widget.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_posts_grid_view.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_reels_grid_view.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/profile_data_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    super.build(context);
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          body: Column(
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
                                              backgroundColor: Color.fromARGB(
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
                                      future: Provider.of<UserPostsProvider>(
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
                                              data:
                                                  postData.allUserPosts.length,
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
                                    future: Provider.of<ProfileDataProvider>(
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
                                          builder: (context, ffpData, child) {
                                        return ProfileDataWidget(
                                          data: ffpData.followers,
                                          label: 'Followers',
                                          onTap: () {},
                                        );
                                      });
                                    },
                                  ),
                                  FutureBuilder(
                                    future: Provider.of<ProfileDataProvider>(
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
                                          builder: (context, ffpData, child) {
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
                              const Text(
                                'Oh, well whatever happens happens.',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              SizedBoxConstants.sizedboxh20,
                              if (widget.chatUser.userId == user.uid)
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              settings: const RouteSettings(
                                                  name: EditProfilePage
                                                      .routename),
                                              builder: (context) =>
                                                  const EditProfilePage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Provider.of<ThemeProvider>(
                                                          context)
                                                      .isLightTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            color: Provider.of<ThemeProvider>(
                                                        context)
                                                    .isLightTheme
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 38, 38, 39),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text('Edit Profile'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Provider.of<ThemeProvider>(
                                                        context)
                                                    .isLightTheme
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .isLightTheme
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 38, 38, 39),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text('Share Profile'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.chatUser.userId != user.uid)
                                StreamBuilder(
                                  stream: UserApis.getAllFollowings(
                                      UserApis.user!.uid),
                                  builder: (context, snapshot) {
                                    final data = snapshot.data?.docs;
                                    list = [];
                                    if (snapshot.hasData) {
                                      for (var i in data!) {
                                        list.add(i.data()['userId']);
                                      }
                                    }

                                    if (list.isNotEmpty) {
                                      haveFollowed =
                                          list.contains(widget.chatUser.userId);
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
                                                    .unfollow(widget.chatUser);
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
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangeNotifierProvider<
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
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .isLightTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                      color:
                                                          Provider.of<ThemeProvider>(
                                                                      context)
                                                                  .isLightTheme
                                                              ? Colors.white
                                                              : const Color
                                                                  .fromARGB(255,
                                                                  48, 47, 47),
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                      indicatorSize: TabBarIndicatorSize.tab,
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
                                              userId: widget.chatUser.userId),
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
        ),
      ),
    );
  }
}
