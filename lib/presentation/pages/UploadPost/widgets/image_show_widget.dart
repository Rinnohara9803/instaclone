import 'package:flutter/material.dart';
import 'dart:io';

class ImageShowWidget extends StatefulWidget {
  final String file;
  final bool isSelected;
  final Function onTap;
  const ImageShowWidget(
      {super.key,
      required this.file,
      required this.isSelected,
      required this.onTap});

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
        ],
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
