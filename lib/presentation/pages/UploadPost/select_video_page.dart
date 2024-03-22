import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/UploadPost/add_post_details_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/widgets/video_item_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';
import '../../../models/video_file_model.dart';

class SelectVideoPage extends StatefulWidget {
  static const String routename = '/select-video-page';
  const SelectVideoPage({
    Key? key,
  }) : super(key: key);

  @override
  _SelectVideoPageState createState() => _SelectVideoPageState();
}

class _SelectVideoPageState extends State<SelectVideoPage> {
  List<VideoFileModel>? videoFileFolders;
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  VideoFileModel? selectedVideoFolder;
  Files? video;

  @override
  void initState() {
    super.initState();
    getVideosPath();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _controller!.pause();
  }

  bool selectMultipleVideos = false;
  List<Files> selectedFiles = [];

  void toggleSelectMultipleImages() {
    setState(() {
      selectMultipleVideos = !selectMultipleVideos;
      selectedFiles = [];
    });
    if (selectMultipleVideos && selectedFiles.isEmpty) {
      setState(() {
        selectedFiles.add(video!);
      });
    }
  }

  getVideosPath() async {
    // Path to videos folders
    var videoPath = await StoragePath.videoPath;
    var videos = jsonDecode(videoPath!) as List;
    print('here');
    print(videos);

    // Video file folders
    videoFileFolders =
        videos.map<VideoFileModel>((e) => VideoFileModel.fromJson(e)).toList();
    if (videoFileFolders != null && videoFileFolders!.isNotEmpty) {
      setState(() {
        selectedVideoFolder = videoFileFolders![videoFileFolders!.length - 1];
        video = selectedVideoFolder!.files[0];
        selectedFiles.add(video!);
        _controller?.dispose();
        _controller = VideoPlayerController.file(
          File(video!.path),
        );
        _initializeVideoPlayerFuture = _controller!.initialize();
        _controller!.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _controller!.pause();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddPostDetailsPage(
                              images: const [], videos: selectedFiles),
                        ),
                      );
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  // width: double.infinity,
                  child: video != null
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
                              }
                            });
                          },
                          child: FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(
                                    _controller!,
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.grey,
                                );
                              }
                            },
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<VideoFileModel>(
                      iconEnabledColor: Colors.white,
                      items: getItems(),
                      onChanged: (VideoFileModel? d) {
                        assert(d!.files.isNotEmpty);
                        setState(() {
                          selectedVideoFolder = d;
                          video = d!.files[0];
                          _controller?.dispose();
                          _controller = VideoPlayerController.file(
                            File(video!.path),
                          );
                          _initializeVideoPlayerFuture =
                              _controller!.initialize();
                          _controller!.play();
                        });
                      },
                      value: selectedVideoFolder,
                      dropdownColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.white
                              : const Color.fromARGB(255, 72, 71, 71),
                    ),
                  ),
                  Row(
                    children: [
                      selectMultipleVideos
                          ? TextButton.icon(
                              label: Text(
                                'Select a video',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onPressed: () {
                                toggleSelectMultipleImages();
                              },
                              icon: const Icon(
                                Icons.image,
                              ),
                            )
                          : TextButton.icon(
                              label: Text(
                                'Select multiple videos',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onPressed: () {
                                toggleSelectMultipleImages();
                              },
                              icon: const Icon(
                                Icons.grid_on_sharp,
                              ),
                            ),
                      const Icon(
                        Icons.camera_alt,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            selectedVideoFolder == null
                ? Container()
                : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (_, i) {
                        var file = selectedVideoFolder!.files[i];
                        bool isSelected = selectMultipleVideos
                            ? selectedFiles.contains(file)
                            : file == video;
                        return GestureDetector(
                          onTap: () {
                            if (isSelected && selectedFiles.length == 1) {
                              return;
                            }
                            if (isSelected && selectMultipleVideos) {
                              setState(() {
                                selectedFiles.remove(file);
                              });
                            }
                            if (selectMultipleVideos && !isSelected) {
                              setState(() {
                                selectedFiles.add(file);
                                video = file;
                              });
                            } else {
                              setState(() {
                                video = file;
                                _controller?.dispose();
                                _controller = VideoPlayerController.file(
                                  File(file.path),
                                );
                                _initializeVideoPlayerFuture =
                                    _controller!.initialize();
                                _controller!.play();
                              });
                            }
                          },
                          child: VideoItemWidget(
                            videoFile: file,
                            isSelected: isSelected,
                          ),
                        );
                      },
                      itemCount: selectedVideoFolder!.files.length,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<VideoFileModel>> getItems() {
    if (videoFileFolders != null) {
      return videoFileFolders!
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.folderName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
          .toList();
    } else {
      return [];
    }
  }
}
