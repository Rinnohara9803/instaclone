import 'dart:math';
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/Home/widgets/story_view_widget.dart';
import 'package:instaclone/providers/user_stories_provider.dart';
import 'package:provider/provider.dart';

class MoreStories extends StatefulWidget {
  final int storyIndex;
  const MoreStories({
    super.key,
    required this.storyIndex,
  });

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories>
    with TickerProviderStateMixin {
  late PageController _pageController;
  AnimationController? _animationController;
  final _pageNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.storyIndex);
    _animationController = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.addListener(_listener);
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
    _pageController.removeListener(_listener);
    _pageController.dispose();
    _pageNotifier.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  void _listener() {
    _pageNotifier.value = _pageController.page!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<UserStoriesProvider>(builder: (context, storyData, _) {
        // return ValueListenableBuilder<double>(
        //     valueListenable: _pageNotifier,
        //     builder: (_, value, child) {
        return PageView.builder(
          onPageChanged: (value) {},
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: storyData.followingsStories.length,
          itemBuilder: (context, index) {
            // final isLeaving = (index - value) <= 0;
            // final t = (index - value);
            // final rotationY = lerpDouble(0, 90, t);
            // final transform = Matrix4.identity();
            // transform.setEntry(3, 2, 0.003);
            // transform.rotateY(double.parse('${-degToRad(rotationY!)}'));
            return GestureDetector(
              onVerticalDragUpdate: (details) => Navigator.of(context).pop(),
              child:
                  // Transform(
                  //   alignment: isLeaving
                  //       ? Alignment.centerRight
                  //       : Alignment.centerLeft,
                  //   transform: transform,
                  //   child:
                  StoryViewWidget(
                userStory: storyData.followingsStories[index],
                index: index,
                pageController: _pageController,
              ),
              // ),
            );
          },
        );
        // });
      }),
    );
  }

  num degToRad(num deg) => deg * (pi / 180.0);
  num radToDeg(num deg) => deg * (180.0 / pi);
}
