import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instaclone/models/video_file_model.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

class VideoItemWidget extends StatefulWidget {
  final Files videoFile;
  final Function setVideoController;
  const VideoItemWidget({
    Key? key,
    required this.videoFile,
    required this.setVideoController,
  }) : super(key: key);

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  File? thumbnail;

  Future<void> getThumbnail() async {
    await VideoCompress.getFileThumbnail(widget.videoFile.path,
            quality: 50, // default(100)
            position: -1 // default(-1)
            )
        .then((value) {
      thumbnail = value;
    }).catchError((e) {
      print(e.toString());
    });
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    print('builder running');
    int milliseconds = int.parse(widget.videoFile.duration);
    Duration duration = Duration(milliseconds: milliseconds);

    String formattedTime = formatDuration(duration);

    return Consumer<FetchMediasProvider>(
        child: FutureBuilder(
          future: getThumbnail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.grey,
              );
            } else if (snapshot.hasError) {
              return Container(
                color: Colors.grey,
              );
            } else {
              return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image(
                  fit: BoxFit.cover,
                  image: FileImage(
                    File(
                      thumbnail!.path,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        builder: (context, fmp, child) {
          bool isSelected = fmp.selectMultipleImages
              ? fmp.selectedVideos.contains(widget.videoFile)
              : fmp.selectedVideo == widget.videoFile;
          return GestureDetector(
            onTap: () {
              if (isSelected && fmp.selectedVideos.length == 1) {
                return;
              }
              if (isSelected && fmp.selectMultipleImages) {
                fmp.removeVideoFromList(widget.videoFile);
              }
              if (fmp.selectMultipleImages && !isSelected) {
                fmp.addVideoToList(widget.videoFile);
                fmp.setSelectedVideo(widget.videoFile);
                widget.setVideoController();
              } else {
                Provider.of<FetchMediasProvider>(context, listen: false)
                    .setSelectedVideo(widget.videoFile);
                widget.setVideoController();
              }
            },
            child: Stack(
              children: [
                child as Widget,
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Text(
                    formattedTime.toString(),
                  ),
                ),
                Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                  if (isSelected) {
                    return Center(
                      child: Container(color: Colors.black.withOpacity(0.6)),
                    );
                  } else {
                    return Center(
                      child: Container(color: Colors.transparent),
                    );
                  }
                }),
                if (fmp.selectMultipleImages && isSelected)
                  Positioned(
                    top: 4,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(
                        7,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      child: Text(
                        (fmp.selectedVideos.indexOf(widget.videoFile) + 1)
                            .toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
