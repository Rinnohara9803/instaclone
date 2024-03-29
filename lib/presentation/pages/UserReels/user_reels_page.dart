import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/UserReels/widgets/user_reels_details.dart';
import 'package:instaclone/providers/user_reels_provider.dart';
import 'package:provider/provider.dart';

class UserReelsPage extends StatefulWidget {
  final int reelsIndex;
  const UserReelsPage({super.key, required this.reelsIndex});

  @override
  State<UserReelsPage> createState() => _UserReelsPageState();
}

class _UserReelsPageState extends State<UserReelsPage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.reelsIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ReelsProvider>(
          builder: (context, reelsData, child) {
            if (reelsData.userReels.isEmpty) {
              return const Center(
                child: Text(
                  'No Reels till date',
                ),
              );
            } else {
              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: reelsData.userReels.length,
                itemBuilder: (context, index) {
                  return UserReelsDetails(
                    reel: reelsData.userReels[index],
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
