import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:instaclone/models/video_file_model.dart';

class FetchMediasProvider with ChangeNotifier {
  bool _selectMultipleImages = false;

  bool get selectMultipleImages {
    return _selectMultipleImages;
  }

  void toggleSelectMultipleImages() {
    _selectMultipleImages = !_selectMultipleImages;
    notifyListeners();
    _selectedVideos = [_selectedVideo!];
    notifyListeners();
  }

  List<Files> _selectedVideos = [];

  List<Files> get selectedVideos {
    return [..._selectedVideos];
  }

  List<VideoFileModel> _videoFileFolders = [];

  List<VideoFileModel> get videoFileFolders {
    return [..._videoFileFolders];
  }

  VideoFileModel? _selectedVideoFileModel;

  VideoFileModel? get selectedVideoFileModel {
    return _selectedVideoFileModel;
  }

  Files? _selectedVideo;

  Files? get selectedVideo {
    return _selectedVideo;
  }

  void addVideoToList(Files video) {
    _selectedVideos = [..._selectedVideos, video];
    notifyListeners();
  }

  void removeVideoFromList(Files video) {
    _selectedVideos.remove(video);
    notifyListeners();
  }

  Future<void> getVideosPath() async {
    try {
      // Path to videos folders
      var videoPath = await StoragePath.videoPath;
      var videos = jsonDecode(videoPath!) as List;

      // Video file folders
      _videoFileFolders = videos
          .map<VideoFileModel>((e) => VideoFileModel.fromJson(e))
          .toList();
      notifyListeners();
      if (videoFileFolders.isNotEmpty) {
        _selectedVideoFileModel = videoFileFolders[videoFileFolders.length - 1];
        notifyListeners();
        _selectedVideo = _selectedVideoFileModel!.files[0];
        notifyListeners();
        _selectedVideos = [_selectedVideo!];
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  changeVideoFileFolder(VideoFileModel vfm) {
    print('folder change');
    _selectedVideoFileModel = vfm;
    notifyListeners();
  }

  setSelectedVideo(Files video) {
    print('video change');
    _selectedVideo = video;
    notifyListeners();
  }
}
