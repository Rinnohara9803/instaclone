import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/apis/user_apis.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/presentation/pages/Chat/chat_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/profile_data_widget.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_posts_grid_view.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_reels_grid_view.dart';
import 'package:instaclone/presentation/pages/UserPosts/user_posts_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/profile_data_provider.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:instaclone/services/sound_recorder.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  final String userId;
  const UserDetails({super.key, required this.userId});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late bool haveFollowed;

  List<String> list = [];

  late Stream getUserInfo;

  @override
  void initState() {
    getUserInfo = ChatApis.getUserInfo(widget.userId);
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ProfileProvider>(context, listen: false)
          .fetchUserProfile(widget.userId),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Consumer<ProfileProvider>(builder: (context, userData, _) {
            return DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(
                children: [
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
                                                      widget.userId),
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
                                        ).getFollowers(widget.userId),
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
                                        ).getFollowings(widget.userId),
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
                                  const Text(
                                    'Oh, well whatever happens happens.',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBoxConstants.sizedboxh20,
                                  if (widget.userId == user!.uid)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EditProfilePage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      Provider.of<ThemeProvider>(
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
                                                        : const Color.fromARGB(
                                                            255, 38, 38, 39),
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                                color:
                                                    Provider.of<ThemeProvider>(
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                  if (widget.userId != user!.uid)
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
                                              list.contains(widget.userId);
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
                                                    ).follow(userData.theUser);
                                                  } else {
                                                    Provider.of<ProfileDataProvider>(
                                                            context,
                                                            listen: false)
                                                        .unfollow(
                                                            userData.theUser);
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
                                                                    user: userData
                                                                        .theUser)),
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
                                                userId: widget.userId,
                                              ),
                                              // SizedBox(),
                                              UserReelsGridView(
                                                  userId: widget.userId),
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
            );
          });
        }
      }),
    );
  }
}
