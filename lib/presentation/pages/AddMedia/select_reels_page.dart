import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/video_file_model.dart';
import 'package:instaclone/presentation/pages/AddMedia/add_reels_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SelectReelsPage extends StatefulWidget {
  final Function navigateBack;
  const SelectReelsPage({super.key, required this.navigateBack});

  @override
  State<SelectReelsPage> createState() => _SelectReelsPageState();
}

class _SelectReelsPageState extends State<SelectReelsPage> {
  List<VideoFileModel>? videoFileFolders;

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
  }

  List<Files> selectedFiles = [];

  void openCamera() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final XFile? image = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(
        seconds: 30,
      ),
    );
    if (image != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddReelsPage(
            videoPath: image.path,
          ),
        ),
      );
    } else {
      return;
    }
  }

  getVideosPath() async {
    // Path to videos folders
    var videoPath = await StoragePath.videoPath;
    var videos = jsonDecode(videoPath!) as List;

    // Video file folders
    videoFileFolders =
        videos.map<VideoFileModel>((e) => VideoFileModel.fromJson(e)).toList();
    if (videoFileFolders != null && videoFileFolders!.isNotEmpty) {
      setState(() {
        selectedVideoFolder = videoFileFolders![videoFileFolders!.length - 1];
        video = selectedVideoFolder!.files[0];
        selectedFiles.add(video!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              const Text('New Reel'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddReelsPage(
                        videoPath: video!.path,
                      ),
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
        Row(
          children: [
            GestureDetector(
              onTap: () {
                openCamera();
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                padding: const EdgeInsets.all(
                  25,
                ),
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context).isLightTheme
                      ? Colors.black38
                      : const Color.fromARGB(255, 45, 44, 44),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                    child: Column(
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    SizedBoxConstants.sizedboxh5,
                    Text(
                      'Camera',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    )
                  ],
                )),
              ),
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
                  iconEnabledColor:
                      Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black
                          : Colors.white,
                  items: getItems(),
                  onChanged: (VideoFileModel? d) {
                    setState(() {
                      selectedVideoFolder = d;
                      video = d!.files[0];
                    });
                  },
                  value: selectedVideoFolder,
                  dropdownColor:
                      Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.white
                          : const Color.fromARGB(255, 72, 71, 71),
                ),
              ),
            ],
          ),
        ),
        selectedVideoFolder == null
            ? Container()
            : Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (_, i) {
                    var file = selectedVideoFolder!.files[i];
                    bool isSelected = file == video;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFiles.add(file);
                          video = file;
                        });
                      },
                      child: VideoReelWidget(
                        videoFile: file,
                        isSelected: isSelected,
                      ),
                    );
                  },
                  itemCount: selectedVideoFolder!.files.length,
                ),
              )
      ],
    );
  }

  List<DropdownMenuItem<VideoFileModel>> getItems() {
    if (videoFileFolders != null) {
      return videoFileFolders!
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
          .toList();
    } else {
      return [];
    }
  }
}

class VideoReelWidget extends StatefulWidget {
  final bool isSelected;
  final Files videoFile;
  const VideoReelWidget(
      {Key? key, required this.videoFile, required this.isSelected})
      : super(key: key);

  @override
  State<VideoReelWidget> createState() => _VideoReelWidgetState();
}

class _VideoReelWidgetState extends State<VideoReelWidget> {
  VideoPlayerController? _controller;
  // Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(
      File(widget.videoFile.path),
    );
    _controller!.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    int milliseconds = int.parse(widget.videoFile.duration);
    Duration duration = Duration(milliseconds: milliseconds);

    String formattedTime = formatDuration(duration);

    return Container(
      color: Colors.grey,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          Positioned(
            bottom: 2,
            right: 2,
            child: Text(
              formattedTime.toString(),
            ),
          ),
          if (widget.isSelected)
            Center(
              child: Container(
                color: widget.isSelected
                    ? Colors.black.withOpacity(0.6)
                    : Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
