import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/ShareProfile/share_profile.dart';

class ShareProfileProvider with ChangeNotifier {
  List<List<Color>> colors = [
    [Colors.red, Colors.blue],
    [Colors.yellow, Colors.blue],
    [Colors.amber, Colors.purple],
    [Colors.cyan, Colors.brown],
    [Colors.orange, Colors.pink],
    [Colors.blue, Colors.green],
    [Colors.red, Colors.red],
    [Colors.indigo, Colors.purple],
  ];

  QrBackgroundState _currentBackgroundState = QrBackgroundState.color;

  QrBackgroundState get currentBackgroundState {
    return _currentBackgroundState;
  }

  List<Color> _selectedColors = const [Colors.red, Colors.blue];

  List<Color> get selectedColors {
    return _selectedColors;
  }

  String _selectedImagePath = '';

  String get selectedImagePath {
    return _selectedImagePath;
  }

  bool _isBlurEnabled = false;

  bool get isBlurEnabled {
    return _isBlurEnabled;
  }

  void setImagePath(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void toggleIsBlurEnabled() {
    _isBlurEnabled = !isBlurEnabled;
    notifyListeners();
  }

  void toggleBackgroundState() {
    if (_currentBackgroundState == QrBackgroundState.color) {
      _currentBackgroundState = QrBackgroundState.image;
      notifyListeners();
      _selectedColors = const [Colors.black, Colors.black];
      notifyListeners();
    } else {
      _currentBackgroundState = QrBackgroundState.color;
      notifyListeners();
      _selectedColors = colors[0];
      notifyListeners();
    }
  }

  void setSelectedColors(List<Color> colors) {
    _selectedColors = colors;
    notifyListeners();
  }
}
