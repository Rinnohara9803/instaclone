import 'dart:convert';
import 'dart:io';
import 'package:instaclone/presentation/pages/UploadPost/select_video_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/widgets/image_show_widget.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/image_file_model.dart';
import '../../resources/themes_manager.dart';
import 'apply_filters_page.dart';

class SelectImageWidget extends StatefulWidget {
  final Function navigateBack;
  final Function setImages;
  const SelectImageWidget({
    super.key,
    required this.navigateBack,
    required this.setImages,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectImageWidgetState createState() => _SelectImageWidgetState();
}

class _SelectImageWidgetState extends State<SelectImageWidget>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;

  List<ImageFileModel>? files;
  ImageFileModel? selectedModel;
  String? image;
  List<String> selectedFiles = [];

  bool selectMultipleImages = false;

  void toggleSelectMultipleImages() {
    setState(() {
      selectMultipleImages = !selectMultipleImages;
      selectedFiles = [];
    });
    if (selectMultipleImages && selectedFiles.isEmpty) {
      setState(() {
        selectedFiles.add(image!);
      });
    }
  }

  bool showGridPaper = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
    getImagesPath();
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(selectMultipleImages);
    // print('the length of selectedFiles is ${selectedFiles.length}');
    return Material(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      widget.navigateBack();
                    },
                    icon: const Icon(Icons.clear)),
                TextButton(
                  onPressed: () {
                    if (!selectMultipleImages) {
                      selectedFiles.clear();
                      selectedFiles.add(image!);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ApplyFilterPage(imagePaths: selectedFiles),
                        ),
                      );
                    } else {
                      if (selectedFiles.isEmpty) {
                        selectedFiles.add(image!);
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ApplyFilterPage(imagePaths: selectedFiles),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: image != null
                    ? GestureDetector(
                        onDoubleTap: () {
                          _toggleZoom();
                        },
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          onInteractionStart: (_) {
                            setState(() {
                              showGridPaper = true;
                            });
                          },
                          onInteractionEnd: (_) {
                            setState(() {
                              showGridPaper = false;
                            });
                          },
                          boundaryMargin: EdgeInsets.all(
                            showGridPaper ? 100 : 0,
                          ),
                          minScale: 0.1,
                          maxScale: 2.0,
                          child: GridPaper(
                            color: showGridPaper
                                ? Colors.black
                                : Colors.transparent,
                            divisions: 1,
                            interval: 1200,
                            subdivisions: 9,
                            child: Image.file(
                              File(image!),
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                Row(
                  children: [
                    selectMultipleImages
                        ? TextButton.icon(
                            label: Text(
                              'Select an image',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            onPressed: () {
                              toggleSelectMultipleImages();
                            },
                            icon: const Icon(
                              Icons.image,
                            ),
                          )
                        : TextButton.icon(
                            label: Text(
                              'Select multiple images',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            onPressed: () {
                              toggleSelectMultipleImages();
                            },
                            icon: const Icon(
                              Icons.grid_on_sharp,
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        widget.setImages();
                      },
                      icon: const Icon(
                        Icons.video_camera_back_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // check for => selected image folder is null
          selectedModel == null
              ? Container()
              // grid view of selected image folder
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (_, i) {
                      var file = selectedModel!.files[i];
                      bool isSelected = selectMultipleImages
                          ? selectedFiles.contains(file)
                          : file == image;

                      return ImageShowWidget(
                          file: file,
                          isSelected: isSelected,
                          onTap: () {
                            if (isSelected && selectedFiles.length == 1) {
                              return;
                            }
                            if (isSelected && selectMultipleImages) {
                              setState(() {
                                selectedFiles.remove(file);
                              });
                            }
                            if (selectMultipleImages && !isSelected) {
                              setState(() {
                                selectedFiles.add(file);
                                image = file;
                              });
                            } else {
                              setState(() {
                                image = file;
                              });
                            }
                          });
                    },
                    itemCount: selectedModel!.files.length,
                  ),
                )
        ],
      ),
    );
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

  void _toggleZoom() {
    if (_transformationController.value.isIdentity()) {
      _transformationController.value = Matrix4.identity()..scale(2.0);
    } else {
      _transformationController.value = Matrix4.identity();
    }
  }
}
