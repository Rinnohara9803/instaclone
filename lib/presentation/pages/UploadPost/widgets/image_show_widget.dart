import 'package:flutter/material.dart';
import 'dart:io';

class ImageShowWidget extends StatefulWidget {
  final String file;
  final bool isSelected;
  final Function onTap;
  final bool selectMultipleImages;
  final List<String> selectedFiles;
  const ImageShowWidget(
      {super.key,
      required this.file,
      required this.isSelected,
      required this.onTap,
      required this.selectMultipleImages,
      required this.selectedFiles});

  @override
  State<ImageShowWidget> createState() => _ImageShowWidgetState();
}

class _ImageShowWidgetState extends State<ImageShowWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.file(
              File(widget.file),
              fit: BoxFit.cover,
            ),
          ),
          // if (widget.isSelected)
          Center(
            child: Container(
              color: widget.isSelected
                  ? Colors.black.withOpacity(0.6)
                  : Colors.transparent,
            ),
          ),
          if (widget.selectMultipleImages && widget.isSelected)
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
                  (widget.selectedFiles.indexOf(widget.file) + 1).toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
