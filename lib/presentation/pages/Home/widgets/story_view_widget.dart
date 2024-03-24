import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/user_stories_provider.dart';
import 'package:instaclone/utilities/my_date_util.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryViewWidget extends StatefulWidget {
  const StoryViewWidget({
    super.key,
    required PageController? pageController,
    required this.index,
    required this.userStory,
  }) : _pageController = pageController;

  final int index;
  final UserStory userStory;
  final PageController? _pageController;

  @override
  State<StoryViewWidget> createState() => _StoryViewWidgetState();
}

class _StoryViewWidgetState extends State<StoryViewWidget> {
  late StoryController _storyController;
  final ValueNotifier _date = ValueNotifier<String>('');

  @override
  void initState() {
    _date.value = widget.userStory.stories[0].storyId.toString();
    _storyController = StoryController();
    super.initState();
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyItems = widget.userStory.stories.map((story) {
      if (story.media == MediaType.image) {
        return StoryItem.pageImage(
          url: story.url,
          controller: _storyController,
        );
      } else if (story.media == MediaType.video) {
        return StoryItem.pageVideo(
          story.url,
          controller: _storyController,
        );
      }
    }).toList();
    return Stack(
      children: [
        StoryView(
          indicatorHeight: IndicatorHeight.medium,
          storyItems: storyItems,
          onStoryShow: (storyItem, index) async {
            final index = storyItems.indexOf(storyItem);
            if (widget.userStory.stories[index].isViewed == false) {
              widget.userStory.stories[index].updateIsViewed();
            }

            if (index > 0) {
              _date.value = widget.userStory.stories[index].storyId.toString();
            }
          },
          onComplete: () {
            widget.userStory.changeIsViewedStatus();
            if (widget.index + 1 ==
                Provider.of<UserStoriesProvider>(context, listen: false)
                    .followingsStories
                    .length) {
              Navigator.of(context).pop();
            } else {
              widget._pageController!.animateToPage(
                widget.index + 1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
          progressPosition: ProgressPosition.top,
          repeat: false,
          controller: _storyController,
        ),
        Positioned(
          top: 45,
          left: 20,
          right: 0,
          child: SizedBox(
            // width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * .2),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.045,
                        width: MediaQuery.of(context).size.height * 0.045,
                        fit: BoxFit.cover,
                        imageUrl: widget.userStory.user.profileImage.isEmpty
                            ? 'no image'
                            : widget.userStory.user.profileImage,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBoxConstants.sizedboxw10,
                    Text(
                      widget.userStory.user.userName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBoxConstants.sizedboxw10,
                    ValueListenableBuilder(
                        valueListenable: _date,
                        builder: (_, value, child) {
                          return Text(
                            MyDateUtil.getUsersStoryTime(
                              context: context,
                              time: value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
