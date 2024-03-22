import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:instaclone/presentation/pages/UploadPost/add_post_details_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/single_image_filter_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/widgets/color_filtered_widget.dart';
import 'package:flutter/material.dart';

class ImageFilterFile {
  final String id;
  ColorFilterModel colorFilterModel;

  ImageFilterFile({
    required this.id,
    required this.colorFilterModel,
  });
}

class ColorFilterModel {
  String filterName;
  ColorFilter colorFilter;

  ColorFilterModel({required this.filterName, required this.colorFilter});
}

class ApplyFilterPage extends StatefulWidget {
  final List<String> imagePaths;
  const ApplyFilterPage({super.key, required this.imagePaths});

  @override
  State<ApplyFilterPage> createState() => _ApplyFilterPageState();
}

class _ApplyFilterPageState extends State<ApplyFilterPage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.80,
  );

  double saturationValue = 1.0;
  late List<ColorFilterModel> colorFilters;
  late List<ImageFilterFile> imageFilterFiles;

  void toggleColorFilter(ColorFilterModel colorFilter) {
    for (var imageFilterFile in imageFilterFiles) {
      setState(() {
        imageFilterFile.colorFilterModel.colorFilter = colorFilter.colorFilter;
        imageFilterFile.colorFilterModel.filterName = colorFilter.filterName;
      });
    }
  }

  // set color filter to individual images
  void setColorFilter(ColorFilter colorFilter, String theId) {
    ImageFilterFile imageFilterFile =
        imageFilterFiles.firstWhere((iff) => iff.id == theId);
    ColorFilterModel selectedColorFilter = colorFilters
        .firstWhere((element) => element.colorFilter == colorFilter);
    setState(() {
      imageFilterFile.colorFilterModel.colorFilter = colorFilter;
      imageFilterFile.colorFilterModel.filterName =
          selectedColorFilter.filterName;
    });
  }

  late ColorFilterModel selectedColorFilter;
  bool isFilterSelected(ColorFilter colorFilter) {
    return selectedColorFilter.colorFilter == colorFilter;
  }

  bool showSlider = false;
  void showSaturationSlider() {
    setState(() {
      showSlider = true;
    });
  }

  void closeSaturationSlider() {
    setState(() {
      showSlider = false;
    });
  }

  @override
  void initState() {
    // Find all examples here: https://api.flutter.dev/flutter/dart-ui/ColorFilter/ColorFilter.matrix.html

    colorFilters = [
      ColorFilterModel(
        filterName: 'normal',
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.dst,
        ),
      ),
      ColorFilterModel(
        filterName: 'grayscale',
        colorFilter: ColorFilter.matrix(<double>[
          /// matrix
          0.2126 * saturationValue, 0.7152 * saturationValue,
          0.0722 * saturationValue, 0, 0,
          0.2126 * saturationValue, 0.7152 * saturationValue,
          0.0722 * saturationValue, 0, 0,
          0.2126 * saturationValue, 0.7152 * saturationValue,
          0.0722 * saturationValue, 0, 0,
          0, 0, 0, 1, 0
        ]),
      ),
      ColorFilterModel(
        filterName: 'sepia',
        colorFilter: ColorFilter.matrix(
          [
            /// matrix
            0.393 * saturationValue, 0.769 * saturationValue,
            0.189 * saturationValue, 0, 0,
            0.349 * saturationValue, 0.686 * saturationValue,
            0.168 * saturationValue, 0, 0,
            0.272 * saturationValue, 0.534 * saturationValue,
            0.131 * saturationValue, 0, 0,
            0, 0, 0, 1, 0,
          ],
        ),
      ),
      ColorFilterModel(
        filterName: 'inverted',
        colorFilter: ColorFilter.matrix(
          <double>[
            /// matrix
            -1, 0, 0, 0, 255 * saturationValue,
            0, -1, 0, 0, 255 * saturationValue,
            0, 0, -1, 0, 255 * saturationValue,
            0, 0, 0, 1, 0,
          ],
        ),
      ),
      ColorFilterModel(
        filterName: 'colorBurn',
        colorFilter: const ColorFilter.mode(
          Colors.red,
          BlendMode.colorBurn,
        ),
      ),
      ColorFilterModel(
        filterName: 'difference',
        colorFilter: const ColorFilter.mode(
          Colors.blue,
          BlendMode.difference,
        ),
      ),
      ColorFilterModel(
        filterName: 'saturation',
        colorFilter: const ColorFilter.mode(
          Colors.red,
          BlendMode.saturation,
        ),
      ),
    ];
    selectedColorFilter = colorFilters[0];

    imageFilterFiles = widget.imagePaths
        .map(
          (imagePath) => ImageFilterFile(
            id: imagePath,
            colorFilterModel: ColorFilterModel(
              filterName: selectedColorFilter.filterName,
              colorFilter: selectedColorFilter.colorFilter,
            ),
          ),
        )
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear)),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddPostDetailsPage(
                            images: imageFilterFiles,
                            videos: [],
                          ),
                        ),
                      );
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

              // image with filters
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageFilterFiles.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (imageFilterFiles.length == 1) {
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SingleImageFilterPage(
                              imagePath: imageFilterFiles[index].id,
                              colorFilter: imageFilterFiles[index]
                                  .colorFilterModel
                                  .colorFilter,
                              changeColorFilter: setColorFilter,
                            ),
                          ),
                        );
                      },
                      child: ColorFilteredWidget(
                        filePath: imageFilterFiles[index].id,
                        colorFilter: imageFilterFiles[index]
                            .colorFilterModel
                            .colorFilter,
                      ),
                    );
                  },
                ),
              ),

              // available filters
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (showSlider)
                      // saturation slider
                      // doesn't function
                      Slider(
                        min: 0,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        thumbColor: Colors.white,
                        max: 100,
                        value: saturationValue * 100,
                        onChanged: (value) {
                          setState(() {
                            saturationValue = value / 100;
                          });
                        },
                      ),
                    // if (showSlider)
                    SizedBox(
                      height: 125,
                      width: double.infinity,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: colorFilters.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  colorFilters[index].filterName.toUpperCase()),
                              SizedBox(
                                height: 100,
                                child: ColorFiltered(
                                  colorFilter: colorFilters[index].colorFilter,
                                  child: InkWell(
                                    onTap: () {
                                      // show saturation slider conditionally
                                      // doesn't function

                                      // if (isFilterSelected(
                                      //     colorFilters[index].colorFilter)) {
                                      //   showSaturationSlider();
                                      // } else {
                                      //   closeSaturationSlider();
                                      // }

                                      // toggle the color filter being applied
                                      toggleColorFilter(
                                        colorFilters[index],
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 5,
                                      ),
                                      height: 120,
                                      width: 100,
                                      child: Image.file(
                                        File(
                                          widget.imagePaths[0],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (showSlider)
                      // saturation confirmation
                      // doesn't function
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              closeSaturationSlider();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              closeSaturationSlider();
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
