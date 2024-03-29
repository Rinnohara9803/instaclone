import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/UploadPost/select_image_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/select_video_page.dart';

class SelectMediaPage extends StatefulWidget {
  final Function navigateBack;
  const SelectMediaPage({super.key, required this.navigateBack});

  @override
  State<SelectMediaPage> createState() => _SelectMediaPageState();
}

class _SelectMediaPageState extends State<SelectMediaPage> {
  final ValueNotifier _selectImages = ValueNotifier<bool>(true);

  void setSelectImages() {
    _selectImages.value = !_selectImages.value;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ValueListenableBuilder(
            valueListenable: _selectImages,
            builder: (context, value, child) {
              if (value == true) {
                return SelectImageWidget(
                  navigateBack: widget.navigateBack,
                  setImages: setSelectImages,
                );
              } else {
                return SelectVideoWidget(
                  navigateBack: widget.navigateBack,
                  setImages: setSelectImages,
                );
              }
            }));
  }
}
