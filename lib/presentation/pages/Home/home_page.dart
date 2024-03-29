import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/Dashboard/widgets/custom_popup_menubutton.dart';
import 'package:instaclone/presentation/pages/Home/widgets/user_stories.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:provider/provider.dart';
import '../UserPosts/widgets/user_post_widget.dart';

class HomePage extends StatefulWidget {
  final Function navigateToChatsPage;
  const HomePage({Key? key, required this.navigateToChatsPage})
      : super(key: key);

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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<UserPostsProvider>(context, listen: false)
              .fetchLatestPosts();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // SliverAppBar with floating behavior
            SliverAppBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'instaclone',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                  ),
                  const CustomPopUpMenuButton(),
                ],
              ),
              actions: [
                Row(
                  children: [
                    const Icon(Icons.favorite_outline),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        widget.navigateToChatsPage();
                      },
                      child: const Icon(Icons.message_outlined),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
              floating: true, // App bar floats over content when scrolled down
              snap: true, // App bar snaps into place when scrolled up
              elevation: 0, // No shadow
            ),

            // User stories
            SliverToBoxAdapter(
              child: const TheStories(),
            ),

            // Divider
            const SliverToBoxAdapter(
              child: Divider(
                color: Colors.white,
              ),
            ),

            // Latest posts
            FutureBuilder(
              future: getLatestPosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Something went wrong.',
                        ),
                      ),
                    ),
                  );
                } else {
                  return Consumer<UserPostsProvider>(
                    builder: (context, postData, child) {
                      if (postData.latestPosts.isEmpty) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
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
                          ),
                        );
                      } else {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final userPost = postData.latestPosts[index];
                              return ChangeNotifierProvider.value(
                                value: userPost,
                                child: const UserPostWidget(),
                              );
                            },
                            childCount: postData.latestPosts.length,
                          ),
                        );
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
