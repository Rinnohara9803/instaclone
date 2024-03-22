import 'dart:io';
import 'package:instaclone/presentation/pages/UploadPost/widgets/color_filtered_widget.dart';
import 'package:flutter/material.dart';

class SingleImageFilterPage extends StatefulWidget {
  final String imagePath;
  final ColorFilter colorFilter;
  final Function(ColorFilter colorFilter, String id) changeColorFilter;
  const SingleImageFilterPage({
    super.key,
    required this.imagePath,
    required this.colorFilter,
    required this.changeColorFilter,
  });

  @override
  State<SingleImageFilterPage> createState() => _SingleImageFilterPageState();
}

class _SingleImageFilterPageState extends State<SingleImageFilterPage> {
  double saturationValue = 1.0;
  late List<ColorFilter> colorFilters;

  void toggleColorFilter(ColorFilter colorFilter) {
    setState(() {
      selectedColorFilter = colorFilter;
    });
  }

  late ColorFilter selectedColorFilter;

  @override
  void initState() {
    // Find all examples here: https://api.flutter.dev/flutter/dart-ui/ColorFilter/ColorFilter.matrix.html

    colorFilters = [
      const ColorFilter.mode(
        Colors.white,
        BlendMode.dst,
      ),
      ColorFilter.matrix(<double>[
        /// matrix
        0.2126 * saturationValue, 0.7152 * saturationValue,
        0.0722 * saturationValue, 0, 0,
        0.2126 * saturationValue, 0.7152 * saturationValue,
        0.0722 * saturationValue, 0, 0,
        0.2126 * saturationValue, 0.7152 * saturationValue,
        0.0722 * saturationValue, 0, 0,
        0, 0, 0, 1, 0
      ]),
      ColorFilter.matrix(
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
      ColorFilter.matrix(
        <double>[
          /// matrix
          -1, 0, 0, 0, 255 * saturationValue,
          0, -1, 0, 0, 255 * saturationValue,
          0, 0, -1, 0, 255 * saturationValue,
          0, 0, 0, 1, 0,
        ],
      ),
      const ColorFilter.mode(
        Colors.red,
        BlendMode.colorBurn,
      ),
      const ColorFilter.mode(
        Colors.blue,
        BlendMode.difference,
      ),
      const ColorFilter.mode(
        Colors.red,
        BlendMode.saturation,
      ),
    ];
    selectedColorFilter = widget.colorFilter;

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: ColorFilteredWidget(
                filePath: widget.imagePath,
                colorFilter: selectedColorFilter,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: colorFilters.length,
                      itemBuilder: (context, index) {
                        return ColorFiltered(
                          colorFilter: colorFilters[index],
                          child: InkWell(
                            onTap: () {
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
                                  widget.imagePath,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.changeColorFilter(
                            selectedColorFilter,
                            widget.imagePath,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
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
    ));
  }
}
