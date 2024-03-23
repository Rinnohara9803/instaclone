import 'package:flutter/material.dart';

class VideoPlayerProvider with ChangeNotifier {
  bool _isMuted = false;

  bool get isMuted {
    return _isMuted;
  }

  void setIsMuted() {
    _isMuted = !_isMuted;
    notifyListeners();
  }
}
