import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/presentation/pages/Home/view_stories.dart';
import 'package:instaclone/presentation/pages/Home/widgets/user_stories.dart';
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
              const TheStories(),
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
