import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:instaclone/models/image_file_model.dart';
import 'package:instaclone/models/video_file_model.dart';
import 'package:video_player/video_player.dart';

class FetchMediasProvider with ChangeNotifier {
  // Manage selected post-files

  List<dynamic> _selectedMedias = [];

  List<dynamic> get selectedMedias {
    return [..._selectedMedias];
  }

  void clearSelectedMedias() {
    _selectedMedias = [];
    notifyListeners();
  }

  void addMediaPostToList(dynamic mediapost) {
    _selectedMedias.add(mediapost);
    notifyListeners();
  }

  void removeMediaPostFromList(dynamic mediapost) {
    _selectedMedias.remove(mediapost);
    notifyListeners();
  }

  // Manage selected video files

  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  VideoPlayerController? get controller {
    return _controller;
  }

  Future<void>? get initializaeVideoPlayerFuture {
    return _initializeVideoPlayerFuture;
  }

  bool _selectMultipleMedias = false;

  bool get selectMultipleMedias {
    return _selectMultipleMedias;
  }

  void toggleSelectMultipleImages() {
    _selectMultipleMedias = !_selectMultipleMedias;
    notifyListeners();
    _selectedMedias = [];
    notifyListeners();
  }

  void toggleToSelectOneMedia() {
    _selectMultipleMedias = false;
    notifyListeners();
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
    addMediaPostToList(
      video,
    );
  }

  void removeVideoFromList(Files video) {
    removeMediaPostFromList(
      video,
    );
  }

  Future<void> getVideosPath() async {
    print('fetch videos running');
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
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void initializeController() {
    if (_controller != null) {
      _controller!.dispose();
    }
    _controller = VideoPlayerController.file(File(_selectedVideo!.path));
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.play();
  }

  changeVideoFileFolder(VideoFileModel vfm) {
    _selectedVideoFileModel = vfm;
    notifyListeners();
    _selectedVideo = vfm.files[0];
    notifyListeners();
    // initializeController();
  }

  void setCurrentVideo() {
    addMediaPostToList(_selectedVideo);
  }

  void setCurrentImage() {
    addMediaPostToList(_selectedImage);
  }

  setSelectedVideo(Files video) {
    _selectedVideo = video;
    notifyListeners();
  }

  void disposeController() {
    print('controller being disposed');
    if (_controller != null) {
      print('controller not null');
      _controller!.pause();
      _controller!.dispose();
    }
  }

  // Manage selected images

  List<ImageFileModel> _imagefiles = [];

  List<ImageFileModel>? get imageFiles {
    return [..._imagefiles];
  }

  ImageFileModel? _selectedImageFolder;

  ImageFileModel? get selectedImageFolder {
    return _selectedImageFolder;
  }

  String? _selectedImage;

  String? get selectedImage {
    return _selectedImage;
  }

  Future<void> getImagesPath() async {
    print('fetch paths running');
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    _imagefiles =
        images.map<ImageFileModel>((e) => ImageFileModel.fromJson(e)).toList();
    notifyListeners();
    if (_imagefiles.isNotEmpty) {
      _selectedImageFolder = _imagefiles[0];
      notifyListeners();
      _selectedImage = _selectedImageFolder!.files[0];
      notifyListeners();
    }
  }

  void changeImageFileFolder(ImageFileModel folder) {
    _selectedImageFolder = folder;
    notifyListeners();
  }

  void setSelectedImage(String image) {
    _selectedImage = image;
    notifyListeners();
  }
}
