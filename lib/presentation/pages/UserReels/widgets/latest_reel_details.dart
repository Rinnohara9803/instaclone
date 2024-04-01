import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';
import 'package:instaclone/presentation/pages/UserReels/widgets/reel_details.dart';

class LatestReelsDetails extends StatefulWidget {
  final ReelModel reel;
  const LatestReelsDetails({super.key, required this.reel});

  @override
  State<LatestReelsDetails> createState() => _LatestReelsDetailsState();
}

class _LatestReelsDetailsState extends State<LatestReelsDetails> {
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // Provider.of<ProfileProvider>(context, listen: false)
    //     .fetchUserProfile(widget.reel.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        VideoDetails(widget.reel, widget.reel.video),
        const SizedBox(),
      ],
    );
  }
}
