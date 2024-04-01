import 'package:instaclone/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_reels_grid_view_widget.dart';
import 'package:instaclone/providers/user_reels_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserReelsGridView extends StatefulWidget {
  final String userId;

  const UserReelsGridView({super.key, required this.userId});

  @override
  State<UserReelsGridView> createState() => _UserReelsGridViewState();
}

class _UserReelsGridViewState extends State<UserReelsGridView>
    with AutomaticKeepAliveClientMixin<UserReelsGridView> {
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
    // if (currentLimit >
    //     Provider.of<ReelsProvider>(
    //       context,
    //       listen: false,
    //     ).allUserReels.length) {
    //   _refreshController.loadComplete();
    //   return;
    // }
    print('refreshing');
    currentLimit = currentLimit + 12;
    await Provider.of<ReelsProvider>(context, listen: false)
        .fetchAllReelsOfUserWithLimit(widget.userId, currentLimit)
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
      future: Provider.of<ReelsProvider>(context, listen: false)
          .fetchAllReelsOfUserWithLimit(widget.userId, currentLimit),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          return Consumer<ReelsProvider>(builder: (context, reelData, child) {
            if (reelData.userReels.isEmpty) {
              return const Center(
                child: Text(
                  'No Reels till date',
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
                  itemCount: reelData.userReels.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: reelData.userReels[index],
                      child: const UserReelsGridViewWidget(),
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
