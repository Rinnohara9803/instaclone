import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/presentation/pages/Home/view_stories.dart';
import 'package:instaclone/presentation/pages/Profile/profile_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';

class UserStoryWidget extends StatefulWidget {
  final int index;
  const UserStoryWidget({
    super.key,
    required this.index,
  });

  @override
  _UserStoryWidgetState createState() => _UserStoryWidgetState();
}

class _UserStoryWidgetState extends State<UserStoryWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showBottomSheet(
    BuildContext context,
    UserStory userStory,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.17,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black45
                          : Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          chatUser: userStory.user,
                          navigateBack: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_2_outlined,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'View Profile',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MoreStories(
                        storyIndex: index,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'View Story',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStory = Provider.of<UserStory>(context);

    return GestureDetector(
      onLongPress: () {
        _animationController.forward().then((value) {
          showBottomSheet(context, userStory, widget.index);
        });
      },
      onLongPressEnd: (_) {
        _animationController.reverse();
      },
      onLongPressCancel: () {
        _animationController.reverse();
      },
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoreStories(
              storyIndex: widget.index,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation as Animation<double>,
            child: Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              height: MediaQuery.of(context).size.height * 0.085,
              width: MediaQuery.of(context).size.height * 0.085,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: userStory.isViewedCompletely
                      ? [
                          Colors.grey,
                          const Color.fromARGB(255, 101, 149, 232),
                        ]
                      : [
                          Colors.amber,
                          Colors.red,
                        ],
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.040,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .2),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.077,
                      width: MediaQuery.of(context).size.height * 0.077,
                      fit: BoxFit.cover,
                      imageUrl: userStory.user.profileImage.isEmpty
                          ? 'no image'
                          : userStory.user.profileImage,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
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
