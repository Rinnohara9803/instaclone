import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class MoreStories extends StatefulWidget {
  const MoreStories({super.key});

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories>
    with TickerProviderStateMixin {
  final storyController = StoryController();

  PageController? _pageController;
  PageController? _childpageController;
  AnimationController? _animationController;
  final _pageNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _childpageController = PageController();
    _animationController = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController!.addListener(_listener);
    });
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.stop();
        _animationController!.reset();
      }
    });
  }

  @override
  void dispose() {
    storyController.dispose();

    _pageController!.removeListener(_listener);
    _pageController!.dispose();
    _childpageController!.dispose();
    _pageNotifier.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  void _listener() {
    _pageNotifier.value = _pageController!.page!;
  }

  @override
  Widget build(BuildContext context) {
    List<StoryItem> stories = [
      StoryItem.text(
        title: "I guess you'd love to see more of our food. That's great.",
        backgroundColor: Colors.blue,
      ),
      StoryItem.text(
        title: "Nice!\n\nTap to continue.",
        backgroundColor: Colors.red,
        textStyle: TextStyle(
          fontFamily: 'Dancing',
          fontSize: 40,
        ),
      ),
      StoryItem.pageImage(
        url:
            "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
        controller: storyController,
      ),
      StoryItem.pageImage(
          url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
          caption: Text(
            "Working with gifs",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController),
      StoryItem.pageVideo(
        'https://firebasestorage.googleapis.com/v0/b/instaclone-3888f.appspot.com/o/posts%2FOW8zjcD3Z1S8oV29dfbSrvfMkW52%2Fstorage%2Femulated%2F0%2FMovies%2FViber%2Fvideo-5cc38942b4e9e9d4f53c3c2769e555b4-V.mp4?alt=media&token=4b9d1999-1e98-42c1-8181-586d8785aa43',
        controller: storyController,
      ),
      StoryItem.pageImage(
        url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        caption: Text(
          "Hello, from the other side",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        controller: storyController,
      ),
      StoryItem.pageImage(
        url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        caption: Text(
          "Hello, from the other side2",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        controller: storyController,
      ),
    ];
    List<StoryItem> stories1 = [
      StoryItem.pageImage(
        url:
            "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
        controller: storyController,
      ),
      StoryItem.pageImage(
          url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
          caption: Text(
            "Working with gifs",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController),
      StoryItem.pageVideo(
        'https://firebasestorage.googleapis.com/v0/b/instaclone-3888f.appspot.com/o/posts%2FOW8zjcD3Z1S8oV29dfbSrvfMkW52%2Fstorage%2Femulated%2F0%2FMovies%2FViber%2Fvideo-5cc38942b4e9e9d4f53c3c2769e555b4-V.mp4?alt=media&token=4b9d1999-1e98-42c1-8181-586d8785aa43',
        controller: storyController,
      ),
    ];

    List storiesUser = [stories, stories1];
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<double>(
          valueListenable: _pageNotifier,
          builder: (_, value, child) {
            return PageView.builder(
              onPageChanged: (value) {},
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                final isLeaving = (index - value) <= 0;
                final t = (index - value);
                final rotationY = lerpDouble(0, 90, t);
                final transform = Matrix4.identity();
                transform.setEntry(3, 2, 0.003);
                transform.rotateY(double.parse('${-degToRad(rotationY!)}'));
                return GestureDetector(
                  onVerticalDragUpdate: (details) =>
                      Navigator.of(context).pop(),
                  child: Transform(
                    alignment: isLeaving
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    transform: transform,
                    child: StoryView(
                      indicatorHeight: IndicatorHeight.medium,
                      storyItems: storiesUser[index],
                      onStoryShow: (storyItem, index) {
                        // print("Showing a story");
                      },
                      onComplete: () {
                        if (index + 1 == storiesUser.length) {
                          Navigator.of(context).pop();
                        } else {
                          _pageController!.animateToPage(
                            index + 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      progressPosition: ProgressPosition.top,
                      repeat: false,
                      controller: storyController,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  num degToRad(num deg) => deg * (pi / 180.0);
  num radToDeg(num deg) => deg * (180.0 / pi);
}
