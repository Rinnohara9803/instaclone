import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/presentation/pages/Home/widgets/add_story_widget.dart';
import 'package:instaclone/presentation/pages/Home/widgets/story_shimmer_widget.dart';
import 'package:instaclone/presentation/pages/Home/widgets/user_story_widget.dart';
import 'package:instaclone/providers/user_stories_provider.dart';
import 'package:provider/provider.dart';

class TheStories extends StatefulWidget {
  const TheStories({
    Key? key,
  }) : super(key: key);

  @override
  State<TheStories> createState() => _TheStoriesState();
}

class _TheStoriesState extends State<TheStories> {
  Future<void> fetchStories() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    try {
      await Provider.of<UserStoriesProvider>(context, listen: false)
          .fetchFollowingsStories()
          .then((value) {
        Provider.of<UserStoriesProvider>(context, listen: false)
            .fetchMyStory(id);
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      height: MediaQuery.of(context).size.height * 0.13,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchStories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const StoryShimmerWidget();
                } else {
                  return Consumer<UserStoriesProvider>(
                    builder: (context, storyData, _) {
                      if (storyData.followingsStories.isEmpty) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (storyData.myStory == null)
                                const AddStoryWidget(),
                              ...storyData.followingsStories.map((e) {
                                return ChangeNotifierProvider.value(
                                  value: e,
                                  child: UserStoryWidget(
                                    index:
                                        storyData.followingsStories.indexOf(e),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (storyData.myStory == null)
                                const AddStoryWidget(),
                              ...storyData.followingsStories.map((e) {
                                return ChangeNotifierProvider.value(
                                  value: e,
                                  child: UserStoryWidget(
                                    index:
                                        storyData.followingsStories.indexOf(e),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
