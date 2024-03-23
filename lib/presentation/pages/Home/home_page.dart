import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/presentation/pages/Home/stories.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:provider/provider.dart';
import '../../resources/constants/sizedbox_constants.dart';
import '../UserPosts/widgets/user_post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  Future<void>? getLatestPosts;

  List<VideoStory> videoStories = [
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'john_doesdfsdfsdsdsf',
      avatarUrl:
          'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    ),
  ];

  @override
  void initState() {
    getLatestPosts = Provider.of<UserPostsProvider>(context, listen: false)
        .fetchLatestPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.black,
      onRefresh: () async {
        await Provider.of<UserPostsProvider>(context, listen: false)
            .fetchLatestPosts();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // dummy story datas
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                height: 120,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 7,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Consumer<ProfileProvider>(
                                    builder: (context, profileData, _) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (profileData
                                          .chatUser.profileImage.isNotEmpty)
                                        CircleAvatar(
                                          radius: 34,
                                          backgroundImage: NetworkImage(
                                              profileData
                                                  .chatUser.profileImage),
                                        ),
                                      if (profileData
                                          .chatUser.profileImage.isEmpty)
                                        const CircleAvatar(
                                          radius: 34,
                                          child: Icon(
                                            Icons.person,
                                          ),
                                        ),
                                      SizedBoxConstants.sizedboxh5,
                                      Text(
                                        'Your story',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  );
                                }),
                                Positioned(
                                  bottom: 20,
                                  right: -3,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.blue,
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ...videoStories.map((videoStory) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Container(
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MoreStories(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 71,
                                          width: 71,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.amber,
                                                Colors.red,
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 34,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              child: CircleAvatar(
                                                radius: 31,
                                                backgroundImage: NetworkImage(
                                                  videoStory.avatarUrl,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBoxConstants.sizedboxh5,
                                      Text(
                                        videoStory.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
              ),

              // latest posts
              FutureBuilder(
                future: getLatestPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Something went wrong.',
                        ),
                      ),
                    );
                  } else {
                    return Consumer<UserPostsProvider>(
                      builder: (context, postData, child) {
                        if (postData.latestPosts.isEmpty) {
                          return SizedBox(
                            height: 400,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'No posts to view.',
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Provider.of<UserPostsProvider>(
                                              context,
                                              listen: false)
                                          .fetchLatestPosts();
                                    },
                                    child: const Text(
                                      'Refresh',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Column(
                            children: postData.latestPosts
                                .map((userPost) => ChangeNotifierProvider.value(
                                      value: userPost,
                                      child: const UserPostWidget(),
                                    ))
                                .toList(),
                          );
                          // return Expanded(
                          //   child: ListView.builder(
                          //     // controller: widget.scrollController,
                          //     shrinkWrap: true,
                          //     itemCount: postData.allUserPosts.length,
                          //     itemBuilder: (context, index) {
                          //       return ChangeNotifierProvider.value(
                          //         value: postData.allUserPosts[index],
                          //         child: const UserPostWidget(),
                          //       );
                          //     },
                          //   ),
                          // );
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoStory {
  final String videoUrl;
  final String username;
  final String avatarUrl;

  VideoStory({
    required this.videoUrl,
    required this.username,
    required this.avatarUrl,
  });
}
