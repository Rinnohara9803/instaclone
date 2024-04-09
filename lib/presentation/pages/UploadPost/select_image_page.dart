import 'dart:io';
import 'package:instaclone/presentation/pages/UploadPost/add_post_details_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/widgets/image_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/image_file_model.dart';
import '../../resources/themes_manager.dart';

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

  bool showGridPaper = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
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
                    icon: const Icon(
                      Icons.clear,
                    )),
                Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                  return TextButton(
                    onPressed: () {
                      if (fmp.selectedMedias.isEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AddPostDetailsPage(
                              medias: [fmp.selectedImage],
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AddPostDetailsPage(
                              medias: fmp.selectedMedias,
                            ),
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
                  );
                }),
              ],
            ),
          ),
          Stack(
            children: [
              Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: fmp.selectedImage != null
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
                                File(fmp.selectedImage!),
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                );
              }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // drop-down to swtich between different image folders
                  DropdownButtonHideUnderline(
                    child: DropdownButton<ImageFileModel>(
                      iconEnabledColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.black
                              : Colors.white,
                      items: fmp.imageFiles!
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
                          .toList(),
                      onChanged: (ImageFileModel? d) {
                        fmp.changeImageFileFolder(d!);
                        fmp.setSelectedImage(d.files[0]);
                      },
                      value: fmp.selectedImageFolder,
                      dropdownColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.white
                              : const Color.fromARGB(255, 72, 71, 71),
                    ),
                  ),

                  // toggling select-multiple-images button
                  Row(
                    children: [
                      fmp.selectMultipleMedias
                          ? GestureDetector(
                              onTap: () {
                                fmp.toggleSelectMultipleImages();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  7,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).errorColor,
                                  ),
                                  color: Colors.blueAccent,
                                ),
                                child: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                fmp.toggleSelectMultipleImages();
                                fmp.setCurrentImage();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  7,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).errorColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.copy,
                                  color: Theme.of(context).errorColor,
                                  size: 18,
                                ),
                              ),
                            ),
                      IconButton(
                        onPressed: () {
                          widget.setImages();
                        },
                        icon: const Icon(
                          Icons.ondemand_video,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),

          // check for => selected image folder is null
          Selector<FetchMediasProvider, ImageFileModel?>(
              selector: (ctx, provider) => provider.selectedImageFolder,
              builder: (context, selectedImageFolder, child) {
                if (selectedImageFolder == null) {
                  return const SizedBox();
                } else {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (_, i) {
                        var file = selectedImageFolder.files[i];

                        return ImageShowWidget(
                          file: file,
                        );
                      },
                      itemCount: selectedImageFolder.files.length,
                    ),
                  );
                }
              })
        ],
      ),
    );
  }

  void _toggleZoom() {
    if (_transformationController.value.isIdentity()) {
      _transformationController.value = Matrix4.identity()..scale(2.0);
    } else {
      _transformationController.value = Matrix4.identity();
    }
  }
}
