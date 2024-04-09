// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/AddMedia/add_story_page.dart';
import 'package:instaclone/presentation/pages/AddMedia/select_reels_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/select_media_page.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:provider/provider.dart';

class AddPostOrReelsOrStoryPage extends StatefulWidget {
  final Function navigateBack;
  const AddPostOrReelsOrStoryPage({super.key, required this.navigateBack});

  @override
  State<AddPostOrReelsOrStoryPage> createState() =>
      _AddPostOrReelsOrStoryPageState();
}

class _AddPostOrReelsOrStoryPageState extends State<AddPostOrReelsOrStoryPage> {
  final _pageController = PageController(initialPage: 0);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void jumpPage(int index) {
    _pageController.jumpToPage(index);
  }

  double getHorizontalPosition(int index, double width) {
    switch (index) {
      case 0:
        return width * 0.2;
      case 1:
        return width * 0.285;
      case 2:
        return width * 0.36;
      default:
        return width * 0.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: _onItemTapped,
              children: [
                SelectMediaPage(navigateBack: widget.navigateBack),
                AddStoryPage(
                  navigateBack: widget.navigateBack,
                ),
                SelectReelsPage(
                  navigateBack: widget.navigateBack,
                ),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: 400,
              ),
              bottom: MediaQuery.of(context).size.height * 0.01,
              curve: Curves.easeIn,
              right: getHorizontalPosition(
                  _selectedIndex, MediaQuery.of(context).size.width),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        jumpPage(0);
                      },
                      child: Text(
                        'Post',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        jumpPage(1);
                      },
                      child: Text(
                        'Story',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FetchMediasProvider>(context, listen: false)
                            .disposeController();
                        jumpPage(2);
                      },
                      child: Text(
                        'Reel',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: _selectedIndex == 2
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
