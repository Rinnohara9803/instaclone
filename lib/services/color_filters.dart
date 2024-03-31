import 'package:instaclone/models/filter.dart';

class FilterClass {
  List<Filter> filtersList() {
    return <Filter>[
      Filter(
        filterName: 'Normal',
        matrix: [
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      Filter(
        filterName: 'Purple',
        matrix: <double>[
          1,
          -0.2,
          0,
          0,
          0,
          0,
          1,
          0,
          -0.1,
          0,
          0,
          1.2,
          1,
          0.1,
          0,
          0,
          0,
          1.7,
          1,
          0
        ],
      ),
      Filter(
        filterName: 'Grayscale',
        matrix: <double>[
          /// matrix
          0.2126 * 1.0, 0.7152 * 1.0,
          0.0722 * 1.0, 0, 0,
          0.2126 * 1.0, 0.7152 * 1.0,
          0.0722 * 1.0, 0, 0,
          0.2126 * 1.0, 0.7152 * 1.0,
          0.0722 * 1.0, 0, 0,
          0, 0, 0, 1, 0
        ],
      ),
      Filter(
        filterName: 'Sepia',
        matrix: [
          /// matrix
          0.393 * 1.0, 0.769 * 1.0,
          0.189 * 1.0, 0, 0,
          0.349 * 1.0, 0.686 * 1.0,
          0.168 * 1.0, 0, 0,
          0.272 * 1.0, 0.534 * 1.0,
          0.131 * 1.0, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        filterName: 'Inverted',
        matrix: <double>[
          /// matrix
          -1, 0, 0, 0, 255 * 1.0,
          0, -1, 0, 0, 255 * 1.0,
          0, 0, -1, 0, 255 * 1.0,
          0, 0, 0, 1, 0,
        ],
      ),
    ];
  }
}
