import 'dart:io';

import 'package:flutter/material.dart';

class ColorFilteredWidget extends StatelessWidget {
  const ColorFilteredWidget({
    super.key,
    required this.filePath,
    required this.colorFilter,
  });

  final String filePath;
  final ColorFilter colorFilter;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      color: Colors.black,
      child: ColorFiltered(
        colorFilter: colorFilter,
        child: Image.file(
          File(
            filePath,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
