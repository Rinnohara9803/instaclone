import 'package:flutter/material.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/presentation/pages/Home/view_stories.dart';
import 'package:instaclone/presentation/pages/Home/widgets/story_shimmer_widget.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/user_stories_provider.dart';
import 'package:provider/provider.dart';

class TheStories extends StatelessWidget {
  const TheStories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      height: 120,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
                future: Provider.of<UserStoriesProvider>(context, listen: false)
                    .fetchFollowingsStories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const StoryShimmerWidget();
                  } else {
                    return Consumer<UserStoriesProvider>(
                        builder: (context, storyData, _) {
                      if (storyData.followingsStories.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Stories',
                            textAlign: TextAlign.start,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storyData.followingsStories.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: storyData.followingsStories[index],
                              child: UserStoryWidget(
                                index: index,
                              ),
                            );
                          },
                        );
                      }
                    });
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class UserStoryWidget extends StatelessWidget {
  final int index;
  const UserStoryWidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final userStory = Provider.of<UserStory>(context);
    return Container(
      width: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MoreStories(
                    storyIndex: index,
                  ),
                ),
              );
            },
            child: Container(
              height: 71,
              width: 71,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: userStory.isViewedCompletely
                      ? [
                          Colors.grey,
                          Colors.black12,
                        ]
                      : [
                          Colors.amber,
                          Colors.red,
                        ],
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: 31,
                    backgroundImage: NetworkImage(
                      userStory.user.profileImage,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBoxConstants.sizedboxh5,
          Text(
            userStory.user.userName,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
