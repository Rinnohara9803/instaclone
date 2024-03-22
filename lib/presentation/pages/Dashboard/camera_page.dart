import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      log('Image Path: ${image.path}');
      // setState(
      //   () => _isUploading = true,
      // );

      // setState(
      //   () => _isUploading = false,
      // );
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
