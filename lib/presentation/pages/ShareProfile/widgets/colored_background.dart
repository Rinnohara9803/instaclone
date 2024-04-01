import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instaclone/providers/share_profile_provider.dart';
import 'package:provider/provider.dart';

class ColoredBackground extends StatefulWidget {
  const ColoredBackground({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  State<ColoredBackground> createState() => _ColoredBackgroundState();
}

class _ColoredBackgroundState extends State<ColoredBackground> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShareProfileProvider>(
        builder: (context, shareProfileData, child) {
      return GestureDetector(
        onTap: () {
          Random random = Random();

          // Generate a random number between 1 and 10 (inclusive)
          int randomNumber = random.nextInt(shareProfileData.colors.length);
          shareProfileData
              .setSelectedColors(shareProfileData.colors[randomNumber]);
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: shareProfileData.selectedColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
      );
    });
  }
}
