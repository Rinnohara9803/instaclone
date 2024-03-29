import 'package:instaclone/presentation/pages/Profile/widgets/user_post_grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../providers/user_posts_provider.dart';

class UserPostsGridView extends StatefulWidget {
  final String userId;

  const UserPostsGridView({super.key, required this.userId});

  @override
  State<UserPostsGridView> createState() => _UserPostsGridViewState();
}

class _UserPostsGridViewState extends State<UserPostsGridView>
    with AutomaticKeepAliveClientMixin<UserPostsGridView> {
  @override
  bool get wantKeepAlive => true;
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  int currentLimit = 12;

  void _onRefresh() async {
    if (currentLimit >
        Provider.of<UserPostsProvider>(
          context,
          listen: false,
        ).allUserPosts.length) {
      _refreshController.loadComplete();
      return;
    }
    print('refreshing');
    currentLimit = currentLimit + 12;
    await Provider.of<UserPostsProvider>(context, listen: false)
        .fetchAllPostsOfUserWithLimit(widget.userId, currentLimit)
        .then((value) {
      _refreshController.loadComplete();
    }).catchError((e) {
      _refreshController.loadFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: Provider.of<UserPostsProvider>(context, listen: false)
          .fetchAllPostsOfUserWithLimit(widget.userId, currentLimit),
      builder: (context, snapshot) {
        print('running');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            return Consumer<UserPostsProvider>(
                builder: (context, postData, child) {
              if (postData.userPosts.isEmpty) {
                return const Center(
                  child: Text(
                    'No posts till date',
                  ),
                );
              } else {
                return SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: false,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onRefresh,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const SizedBox();
                      } else if (mode == LoadStatus.loading) {
                        body = const CircularProgressIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed!");
                      } else {
                        body = const SizedBox();
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(
                          child: body,
                        ),
                      );
                    },
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: postData.userPosts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: postData.userPosts[index],
                        child: const UserPostGridViewWidget(),
                      );
                    },
                  ),
                );
              }
            });
        }
      },
    );
  }
}
