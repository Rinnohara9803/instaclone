import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/presentation/pages/ShareProfile/share_profile.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/share_profile_provider.dart';
import 'package:provider/provider.dart';

class ImagedBackground extends StatefulWidget {
  final double height;
  final double width;
  const ImagedBackground(
      {super.key, required this.height, required this.width});

  @override
  State<ImagedBackground> createState() => _ImagedBackgroundState();
}

class _ImagedBackgroundState extends State<ImagedBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ShareProfileProvider>(builder: (context, spd, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 70);
                    if (image != null) {
                      spd.setImagePath(image.path);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.photo_camera,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Change background picture',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Blur',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Switch(
                        value: spd.isBlurEnabled,
                        onChanged: (value) {
                          spd.toggleIsBlurEnabled();
                          // Apply blur effect or remove blur as needed based on 'value'
                          // You can use this value to control the blur effect in your UI
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShareProfileProvider>(
        builder: (context, shareProfileData, child) {
      return Stack(
        children: [
          shareProfileData.selectedImagePath.isNotEmpty
              ? Image.file(
                  File(shareProfileData.selectedImagePath),
                  height: widget.height,
                  width: widget.width,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: widget.height,
                  width: widget.width,
                  color: Colors.black12,
                ), // Render empty container if no image selected
          shareProfileData.selectedImagePath.isNotEmpty &&
                  shareProfileData.isBlurEnabled == true
              ? Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0), // Adjust blur intensity as needed
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                )
              : Container(),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: GestureDetector(
              onLongPress: () {
                _animationController.forward();
              },
              onLongPressEnd: (_) {
                _animationController.reverse();
              },
              onLongPressCancel: () {
                _animationController.reverse();
              },
              onTap: () {
                showBottomSheet(context);
              },
              child: ScaleTransition(
                scale: _animation as Animation<double>,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined),
                    SizedBoxConstants.sizedboxw5,
                    Text(
                      'Customize Image',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
