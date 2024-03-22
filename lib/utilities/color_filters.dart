import '../presentation/pages/UploadPost/apply_filters_page.dart';
import 'package:flutter/material.dart';

class ColorFilters {
  static List<ColorFilterModel> colorFilterModels = [
    ColorFilterModel(
      filterName: 'normal',
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.dst,
      ),
    ),
    ColorFilterModel(
      filterName: 'grayscale',
      colorFilter: const ColorFilter.matrix(<double>[
        /// matrix
        0.2126, 0.7152,
        0.0722, 0, 0,
        0.2126, 0.7152,
        0.0722, 0, 0,
        0.2126, 0.7152,
        0.0722, 0, 0,
        0, 0, 0, 1, 0
      ]),
    ),
    ColorFilterModel(
      filterName: 'sepia',
      colorFilter: const ColorFilter.matrix(
        [
          /// matrix
          0.393, 0.769,
          0.189, 0, 0,
          0.349, 0.686,
          0.168, 0, 0,
          0.272, 0.534,
          0.131, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
    ),
    ColorFilterModel(
      filterName: 'inverted',
      colorFilter: const ColorFilter.matrix(
        <double>[
          /// matrix
          -1, 0, 0, 0, 255,
          0, -1, 0, 0, 255,
          0, 0, -1, 0, 255,
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
}
