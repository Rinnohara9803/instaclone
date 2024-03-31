import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:instaclone/models/image_file_model.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_selected_picture_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/select_profile_picture.dart';
import 'package:instaclone/presentation/pages/EditProfile/widgets/click_profile_picture.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';

class SelectProfilePicturePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SelectProfilePicturePage({super.key, required this.cameras});

  @override
  State<SelectProfilePicturePage> createState() =>
      _SelectProfilePicturePageState();
}

class _SelectProfilePicturePageState extends State<SelectProfilePicturePage> {
  final ValueNotifier _currentIndexNotifier = ValueNotifier(0);
  final ValueNotifier _pageNotifier = ValueNotifier<double>(0);
  final pageController = PageController(initialPage: 0);

  List<ImageFileModel>? files;
  ImageFileModel? selectedModel;
  String? image;

  void setImage(String imagePath) {
    setState(() {
      image = imagePath;
    });
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    files =
        images.map<ImageFileModel>((e) => ImageFileModel.fromJson(e)).toList();
    if (files != null && files!.isNotEmpty) {
      setState(() {
        selectedModel = files![0];
        image = files![0].files[0];
      });
    }
  }

  List<DropdownMenuItem<ImageFileModel>> getItems() {
    if (files != null) {
      return files!
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.folder.length > 8
                      ? "${e.folder.substring(
                          0,
                          8,
                        )}.."
                      : e.folder,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
          .toList();
    } else {
      return [];
    }
  }

  @override
  void initState() {
    pageController.addListener(() {
      _pageNotifier.value = pageController.page;
    });
    getImagesPath();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    _currentIndexNotifier.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('page view is running');
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: _pageNotifier,
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: 1.0 - value,
                        duration: const Duration(milliseconds: 100),
                        child: selectProfilePicHeader(
                            context, image == null ? '' : image!),
                      ),
                      AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 100),
                        child: clickProfilePictureHeader(context),
                      ),
                    ],
                  );
                }),
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  _currentIndexNotifier.value = index;
                },
                controller: pageController,
                children: [
                  if (selectedModel == null) const SizedBox(),
                  if (selectedModel != null)
                    SelectProfilePicture(
                      selectedImage: image!,
                      selectedModel: selectedModel!,
                      setImage: setImage,
                    ),
                  ClickProfilePicture(
                    cameras: widget.cameras,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: double.infinity,
              child: ValueListenableBuilder(
                  valueListenable: _currentIndexNotifier,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease,
                              );
                            },
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  'Gallery',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: value == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease,
                              );
                            },
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  'Photo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: value == 1
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Row clickProfilePictureHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        Text(
          'Photo',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Row selectProfilePicHeader(BuildContext context, String imagePath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // drop-down to swtich between different image folders
                DropdownButtonHideUnderline(
                  child: DropdownButton<ImageFileModel>(
                    iconEnabledColor:
                        Provider.of<ThemeProvider>(context).isLightTheme
                            ? Colors.black
                            : Colors.white,
                    items: getItems(),
                    onChanged: (ImageFileModel? d) {
                      assert(d!.files.isNotEmpty);
                      image = d!.files[0];
                      setState(() {
                        selectedModel = d;
                      });
                    },
                    value: selectedModel,
                    dropdownColor:
                        Provider.of<ThemeProvider>(context).isLightTheme
                            ? Colors.white
                            : const Color.fromARGB(255, 72, 71, 71),
                  ),
                ),

                // toggling select-multiple-images button
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EditSelectedPicturePage(path: imagePath),
              ),
            );
          },
          child: const Text(
            'Next',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
