import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:instaclone/models/filter.dart';
import 'package:instaclone/presentation/pages/EditProfile/widgets/adjust_picture.dart';
import 'package:instaclone/presentation/pages/EditProfile/widgets/edit_picture_headers.dart';
import 'package:instaclone/presentation/pages/EditProfile/widgets/filters.dart';
import 'package:instaclone/services/color_filters.dart';

enum EditMode { filterMode, adjustMode }

class EditSelectedPicturePage extends StatefulWidget {
  final String path;
  const EditSelectedPicturePage({super.key, required this.path});

  @override
  State<EditSelectedPicturePage> createState() =>
      _EditSelectedPicturePageState();
}

class _EditSelectedPicturePageState extends State<EditSelectedPicturePage> {
  late ValueNotifier _imageNotifier;
  final ValueNotifier _filterModeNotifier =
      ValueNotifier<EditMode>(EditMode.filterMode);

  Filter selectedFilter = FilterClass().filtersList()[0];

  void switchFilterMode() {
    if (_filterModeNotifier.value == EditMode.filterMode) {
      _filterModeNotifier.value = EditMode.adjustMode;
    } else {
      _filterModeNotifier.value = EditMode.filterMode;
    }
  }

  void setColorFilter(Filter theFilter) {
    print(theFilter.matrix);
    setState(() {
      selectedFilter = theFilter;
    });
  }

  CroppedFile? _croppedFile;

  @override
  void initState() {
    _imageNotifier = ValueNotifier(widget.path);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future cropImage() async {
    _croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          cropGridColor: Theme.of(context).errorColor,
          activeControlsWidgetColor: Colors.blueAccent,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    ) as CroppedFile;
    _imageNotifier.value = _croppedFile!.path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder(
            valueListenable: _filterModeNotifier,
            builder: (context, value, child) {
              return Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        if (value == EditMode.filterMode)
                          FilterHeader(
                            imagePath: _imageNotifier.value,
                          ),
                        if (value == EditMode.adjustMode)
                          AdjustHeader(
                            filterModeNotifier: _filterModeNotifier,
                            setDefaultColorFilter: () {
                              setState(() {
                                selectedFilter = FilterClass().filtersList()[0];
                              });
                            },
                          ),
                        Expanded(
                          flex: 6,
                          child: ValueListenableBuilder(
                              valueListenable: _imageNotifier,
                              builder: (context, value, child) {
                                return ColorFiltered(
                                  colorFilter:
                                      ColorFilter.matrix(selectedFilter.matrix),
                                  child: Image(
                                    image: FileImage(
                                      File(
                                        _imageNotifier.value,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder(
                                      valueListenable: _filterModeNotifier,
                                      builder: (context, value, child) {
                                        if (_filterModeNotifier.value ==
                                            EditMode.filterMode) {
                                          return Filters(
                                            imageNotifier: _imageNotifier,
                                            onTap: setColorFilter,
                                          );
                                        } else {
                                          return AdjustImage(
                                            setColorFilter: setColorFilter,
                                          );
                                        }
                                      }),
                                ),
                                if (value == EditMode.filterMode)
                                  filterFooter(),
                                if (value == EditMode.adjustMode) editFooter(),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Row filterFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            cropImage();
          },
          icon: const Icon(
            Icons.crop_free,
          ),
        ),
        TextButton(
          onPressed: () {
            switchFilterMode();
          },
          child: const Text(
            'Edit',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget editFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            _filterModeNotifier.value = EditMode.filterMode;
          },
          child: const Text(
            'Done',
          ),
        ),
      ),
    );
  }
}
