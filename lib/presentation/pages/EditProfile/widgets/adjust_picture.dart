import 'package:colorfilter_generator/addons.dart';
import 'package:flutter/material.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:instaclone/models/filter.dart';

enum Adjustments { brightness, contrast, saturation, hue, sepia }

class AdjustImage extends StatefulWidget {
  final Function setColorFilter;
  const AdjustImage({super.key, required this.setColorFilter});

  @override
  State<AdjustImage> createState() => _AdjustImageState();
}

class _AdjustImageState extends State<AdjustImage> {
  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;

  bool showB = false;
  bool showC = false;
  bool showS = false;
  bool showH = false;
  bool showSe = false;

  late ColorFilterGenerator adj;

  adjust({b, c, s, h, se}) {
    adj = ColorFilterGenerator(
      name: "Adjust",
      filters: [
        ColorFilterAddons.brightness(b ?? brightness),
        ColorFilterAddons.contrast(c ?? contrast),
        ColorFilterAddons.saturation(s ?? saturation),
        ColorFilterAddons.hue(h ?? hue),
        ColorFilterAddons.sepia(se ?? sepia),
      ],
    );
  }

  @override
  void initState() {
    adjust();
    // widget.setColorFilter(
    //   Filter(
    //     filterName: 'Adjust',
    //     matrix: adj.matrix,
    //   ),
    // );
    super.initState();
  }

  Widget slider({value, onChanged}) {
    return Slider(
      value: value,
      onChanged: onChanged,
      max: 1,
      min: -0.9,
      inactiveColor: Colors.grey,
    );
  }

  Adjustments _selectedAdjustment = Adjustments.brightness;

  bool _showSlider = false;

  void showSlider() {
    setState(() {
      _showSlider = true;
    });
  }

  double getSliderValue(Adjustments adjustment) {
    switch (adjustment) {
      case Adjustments.brightness:
        return brightness;

      case Adjustments.contrast:
        return contrast;
      case Adjustments.saturation:
        return saturation;
      case Adjustments.hue:
        return hue;
      case Adjustments.sepia:
        return sepia;
      default:
        return brightness;
    }
  }

  String getSliderTitle(Adjustments adjustment) {
    switch (adjustment) {
      case Adjustments.brightness:
        return 'Brightness';

      case Adjustments.contrast:
        return 'Contrast';
      case Adjustments.saturation:
        return 'Saturation';
      case Adjustments.hue:
        return 'Hue';
      case Adjustments.sepia:
        return 'Sepia';
      default:
        return 'Brightness';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Visibility(
          visible: _showSlider,
          child: Text(getSliderTitle(_selectedAdjustment)),
        ),
        Visibility(
          visible: _showSlider,
          child: slider(
            value: getSliderValue(_selectedAdjustment),
            onChanged: (value) {
              setState(() {
                switch (_selectedAdjustment) {
                  case Adjustments.brightness:
                    brightness = value;
                    adjust(b: brightness);

                  case Adjustments.contrast:
                    contrast = value;
                    adjust(b: contrast);
                  case Adjustments.saturation:
                    saturation = value;
                    adjust(b: saturation);
                  case Adjustments.hue:
                    hue = value;
                    adjust(b: brightness);
                  case Adjustments.sepia:
                    sepia = value;
                    adjust(b: sepia);
                  default:
                    brightness = value;
                    adjust(b: brightness);
                }
                widget.setColorFilter(
                    Filter(filterName: 'Adjust', matrix: adj.matrix));
              });
            },
          ),
        ),
        Row(
          children: [
            EditDatas(
              onTap: () {
                showSlider();
                setState(() {
                  _selectedAdjustment = Adjustments.brightness;
                });
              },
              iconData: Icons.brightness_6,
              title: 'Brightness',
            ),
            EditDatas(
              onTap: () {
                showSlider();
                setState(() {
                  _selectedAdjustment = Adjustments.contrast;
                });
              },
              iconData: Icons.brightness_2,
              title: 'Contrast',
            ),
            EditDatas(
              onTap: () {
                showSlider();
                setState(() {
                  _selectedAdjustment = Adjustments.saturation;
                });
              },
              iconData: Icons.water_drop,
              title: 'Saturation',
            ),
            EditDatas(
              onTap: () {
                showSlider();
                setState(() {
                  _selectedAdjustment = Adjustments.hue;
                });
              },
              iconData: Icons.filter_hdr,
              title: 'Hue',
            ),
            EditDatas(
              onTap: () {
                showSlider();
                setState(() {
                  _selectedAdjustment = Adjustments.sepia;
                });
              },
              iconData: Icons.filter_vintage,
              title: 'Sepia',
            ),
          ],
        ),
      ],
    );
  }
}

class EditDatas extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;
  const EditDatas(
      {super.key,
      required this.iconData,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(iconData),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
