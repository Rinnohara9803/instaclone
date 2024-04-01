import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:instaclone/presentation/pages/UploadPost/add_post_details_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/widgets/video_item_widget.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';
import '../../../models/video_file_model.dart';

class SelectVideoWidget extends StatefulWidget {
  final Function navigateBack;
  final Function setImages;
  const SelectVideoWidget(
      {Key? key, required this.navigateBack, required this.setImages})
      : super(key: key);

  @override
  _SelectVideoWidgetState createState() => _SelectVideoWidgetState();
}

class _SelectVideoWidgetState extends State<SelectVideoWidget> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  Future<void> getVideoPaths() async {
    var videoPath = await StoragePath.videoPath;
    var videos = jsonDecode(videoPath!) as List;

    // Video file folders
    final videoFileFolders =
        videos.map<VideoFileModel>((e) => VideoFileModel.fromJson(e)).toList();
    if (videoFileFolders.isNotEmpty) {
      final folder = videoFileFolders[videoFileFolders.length - 1];
      final selectedVideo = folder.files[0];
      _controller = VideoPlayerController.file(
        File(selectedVideo.path),
      );
      _initializeVideoPlayerFuture = _controller!.initialize();
      _controller!.play();
    }
  }

  @override
  void initState() {
    super.initState();
    getVideoPaths();
    Provider.of<FetchMediasProvider>(context, listen: false).getVideosPath();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.pause();
    _controller?.dispose();
  }

  // getVideosPath() async {

  // }

  @override
  Widget build(BuildContext context) {
    print('running them files');
    return Material(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.navigateBack();
                  },
                ),
                Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                  return TextButton(
                    onPressed: () {
                      if (fmp.selectedVideos.isEmpty) {
                        return;
                      } else {
                        _controller!.pause();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddPostDetailsPage(
                                images: const [], videos: fmp.selectedVideos),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
          Stack(
            children: [
              Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                if (fmp.selectedVideo == null) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                  );
                } else {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      // width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          if (_controller!.value.isPlaying) {
                            _controller!.pause();
                          } else {
                            _controller!.play();
                          }
                        },
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                color: Colors.grey,
                              );
                            } else if (snapshot.hasError) {
                              return Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            } else {
                              return AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(
                                  _controller!,
                                ),
                              );
                            }
                          },
                        ),
                      ));
                }
              }),
            ],
          ),
          Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<VideoFileModel>(
                      iconEnabledColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.black
                              : Colors.white,
                      items: fmp.videoFileFolders
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.folderName.length > 8
                                      ? "${e.folderName.substring(
                                          0,
                                          8,
                                        )}.."
                                      : e.folderName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (VideoFileModel? d) {
                        fmp.changeVideoFileFolder(d!);
                        fmp.setSelectedVideo(d.files[0]);
                        _controller?.dispose();
                        _controller = VideoPlayerController.file(
                          File(fmp.selectedVideo!.path),
                        );
                        _initializeVideoPlayerFuture =
                            _controller!.initialize();
                        _controller!.play();
                      },
                      value: fmp.selectedVideoFileModel,
                      dropdownColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.white
                              : const Color.fromARGB(255, 72, 71, 71),
                    ),
                  ),
                  Row(
                    children: [
                      fmp.selectMultipleImages
                          ? GestureDetector(
                              onTap: () {
                                fmp.toggleSelectMultipleImages();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  7,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(),
                                  color: Colors.blueAccent,
                                ),
                                child: const Icon(
                                  Icons.copy,
                                  size: 18,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                fmp.toggleSelectMultipleImages();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  7,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(),
                                ),
                                child: const Icon(
                                  Icons.copy,
                                  size: 18,
                                ),
                              ),
                            ),
                      IconButton(
                        onPressed: () {
                          widget.setImages();
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
          Selector<FetchMediasProvider, VideoFileModel?>(
              selector: (ctx, provider) => provider.selectedVideoFileModel,
              builder: (context, selectedVideoFileModel, child) {
                if (selectedVideoFileModel == null) {
                  return Container();
                } else {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (_, i) {
                        var file = selectedVideoFileModel.files[i];

                        return VideoItemWidget(
                          videoFile: file,
                          setVideoController: () {
                            _controller?.dispose();
                            _controller = VideoPlayerController.file(
                              File(file.path),
                            );
                            _initializeVideoPlayerFuture =
                                _controller!.initialize();
                            _controller!.play();
                          },
                        );
                      },
                      itemCount: selectedVideoFileModel.files.length,
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
