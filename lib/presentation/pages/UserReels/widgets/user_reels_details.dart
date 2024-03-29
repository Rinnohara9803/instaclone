import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';
import 'package:instaclone/presentation/pages/UserReels/widgets/reel_details.dart';

class UserReelsDetails extends StatefulWidget {
  final ReelModel reel;
  const UserReelsDetails({super.key, required this.reel});

  @override
  State<UserReelsDetails> createState() => _UserReelsDetailsState();
}

class _UserReelsDetailsState extends State<UserReelsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoDetails(widget.reel, widget.reel.video),
    );
  }
}
