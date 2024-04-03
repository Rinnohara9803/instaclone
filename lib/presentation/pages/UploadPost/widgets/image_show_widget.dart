import 'package:flutter/material.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ImageShowWidget extends StatefulWidget {
  final String file;

  const ImageShowWidget({
    super.key,
    required this.file,
  });

  @override
  State<ImageShowWidget> createState() => _ImageShowWidgetState();
}

class _ImageShowWidgetState extends State<ImageShowWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FetchMediasProvider>(
      child: SizedBox(
        width: double.infinity,
        child: Image.file(
          File(widget.file),
          fit: BoxFit.cover,
        ),
      ),
      builder: (context, fmp, child) {
        bool isSelected = fmp.selectMultipleMedias
            ? fmp.selectedMedias.contains(widget.file)
            : fmp.selectedImage == widget.file;
        return GestureDetector(
          onTap: () {
            if (isSelected && fmp.selectedMedias.length == 1) {
              return;
            } else if (isSelected && fmp.selectMultipleMedias) {
              fmp.removeMediaPostFromList(widget.file);
              fmp.setSelectedImage(widget.file);
            } else if (fmp.selectMultipleMedias && !isSelected) {
              fmp.addMediaPostToList(widget.file);
              fmp.setSelectedImage(widget.file);
            } else {
              fmp.setSelectedImage(widget.file);
            }
          },
          child: Stack(
            children: [
              child as Widget,
              if (isSelected)
                Center(
                  child: Container(color: Colors.black.withOpacity(0.6)),
                ),
              if (fmp.selectMultipleMedias && isSelected)
                Positioned(
                  top: 4,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(
                      7,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: Text(
                      (fmp.selectedMedias.indexOf(widget.file) + 1).toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              if (fmp.selectMultipleMedias && !isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(
                      9,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
