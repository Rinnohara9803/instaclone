import 'package:flutter/material.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/presentation/pages/UserReels/widgets/reel_details.dart';

class UserReelsDetails extends StatefulWidget {
  final UserPostModel reel;
  const UserReelsDetails({super.key, required this.reel});

  @override
  State<UserReelsDetails> createState() => _UserReelsDetailsState();
}

class _UserReelsDetailsState extends State<UserReelsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoDetails(widget.reel, widget.reel.medias[0].url),
    );
  }
}
