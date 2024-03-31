import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/UserReels/widgets/latest_reel_details.dart';
import 'package:instaclone/providers/user_reels_provider.dart';
import 'package:provider/provider.dart';

class LatestReelsPage extends StatefulWidget {
  const LatestReelsPage({
    super.key,
  });

  @override
  State<LatestReelsPage> createState() => _LatestReelsPageState();
}

class _LatestReelsPageState extends State<LatestReelsPage>
    with AutomaticKeepAliveClientMixin<LatestReelsPage> {
  @override
  bool get wantKeepAlive => true;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: Provider.of<ReelsProvider>(context, listen: false)
            .fetchLatestReels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Consumer<ReelsProvider>(
              builder: (context, reelsData, child) {
                if (reelsData.latestReels.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reels available.',
                    ),
                  );
                } else {
                  return PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: reelsData.latestReels.length,
                    itemBuilder: (context, index) {
                      return LatestReelsDetails(
                        reel: reelsData.latestReels[index],
                      );
                    },
                  );
                }
              },
            );
          }
        });
  }
}
