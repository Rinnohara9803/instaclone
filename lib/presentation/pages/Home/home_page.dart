import 'package:flutter/material.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
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
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'john_doesdfsdfsdsdsf',
    //   avatarUrl:
    //       'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'jane_smith',
    //   avatarUrl:
    //       'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'john_doe',
    //   avatarUrl:
    //       'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'jane_smith',
    //   avatarUrl:
    //       'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'john_doe',
    //   avatarUrl:
    //       'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'jane_smith',
    //   avatarUrl:
    //       'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'john_doe',
    //   avatarUrl:
    //       'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    // ),
    // VideoStory(
    //   videoUrl:
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   username: 'jane_smith',
    //   avatarUrl:
    //       'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    // ),
    // // Add more video stories as needed
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
        body: ListView(
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 34,
                                    backgroundImage: NetworkImage(
                                      'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
                                    ),
                                  ),
                                  SizedBoxConstants.sizedboxh5,
                                  Text(
                                    'Your story',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoryPlayerScreen(
                                              videoStory: videoStory,
                                            ),
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
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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
    );
  }
}

class StoryPlayerScreen extends StatefulWidget {
  final VideoStory videoStory;

  const StoryPlayerScreen({super.key, required this.videoStory});

  @override
  State<StoryPlayerScreen> createState() => StoryPlayerScreenState();
}

class StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoStory.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(_onProgressChanged);
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onProgressChanged() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;

    setState(() {
      _progressValue = position.inMilliseconds / duration.inMilliseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
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
