import 'package:instaclone/presentation/pages/UserPosts/widgets/user_post_widget.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UserPostsPage extends StatefulWidget {
  final int postIndex;
  const UserPostsPage({super.key, required this.postIndex});

  @override
  State<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  late ScrollController _scrollController;

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(
        index: widget.postIndex,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).iconTheme.color),
          ),
          title: Text(
            'Posts',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: Consumer<UserPostsProvider>(
          builder: (context, postData, child) {
            if (postData.allUserPosts.isEmpty) {
              return const Center(
                child: Text(
                  'No posts till date',
                ),
              );
            } else {
              return ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: postData.allUserPosts.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: postData.allUserPosts[index],
                    child: const UserPostWidget(),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
