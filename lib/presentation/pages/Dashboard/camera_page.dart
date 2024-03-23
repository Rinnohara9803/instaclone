// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/presentation/pages/AddStory/add_story_page.dart';

class CameraPage extends StatefulWidget {
  final Function navigateBack;
  const CameraPage({super.key, required this.navigateBack});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  void openCamera() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final XFile? image = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(
        seconds: 30,
      ),
    );
    if (image != null) {
      log('Image Path: ${image.path}');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddStoryPage(videoPath: image.path),
        ),
      );
    } else {
      widget.navigateBack();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    openCamera();
    return const SizedBox();
  }
}
