// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:instaclone/models/story.dart';
// import 'package:instaclone/providers/user_stories_provider.dart';
// import 'package:instaclone/utilities/snackbars.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// class AddStoryPage extends StatefulWidget {
//   final String videoPath;
//   const AddStoryPage({super.key, required this.videoPath});

//   @override
//   State<AddStoryPage> createState() => _AddStoryPageState();
// }

// class _AddStoryPageState extends State<AddStoryPage> {
//   late VideoPlayerController _videoPlayerController;
//   Future<void>? _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     _videoPlayerController = VideoPlayerController.file(
//       File(widget.videoPath),
//     );
//     _initializeVideoPlayerFuture = _videoPlayerController.initialize();
//     _videoPlayerController.play();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Provider.of<UserStoriesProvider>(context, listen: false)
//                   .addStory(MediaType.video, widget.videoPath)
//                   .then((value) {
//                 SnackBars.showNormalSnackbar(
//                     context, 'Your story has been posted.');
//               }).catchError((e) {
//                 SnackBars.showErrorSnackBar(context, 'Something went wrong.');
//               });
//             },
//             icon: const Icon(
//               Icons.arrow_forward,
//             ),
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: _videoPlayerController.value.aspectRatio,
//               child: VideoPlayer(
//                 _videoPlayerController,
//               ),
//             );
//           } else {
//             return Container(
//               color: Colors.grey,
//             );
//           }
//         },
//       ),
//     );
//   }
// }
