import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instaclone/models/video_file_model.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

class VideoReelWidget extends StatefulWidget {
  final Files videoFile;
  const VideoReelWidget({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<VideoReelWidget> createState() => _VideoReelWidgetState();
}

class _VideoReelWidgetState extends State<VideoReelWidget> {
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

    return GestureDetector(
      onTap: () {
        Provider.of<FetchMediasProvider>(
          context,
          listen: false,
        ).setSelectedVideo(widget.videoFile);
      },
      child: Stack(
        children: [
          FutureBuilder(
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
          Positioned(
            bottom: 2,
            right: 2,
            child: Text(
              formattedTime.toString(),
            ),
          ),
          Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
            if (fmp.selectedVideo == widget.videoFile) {
              return Center(
                child: Container(color: Colors.black.withOpacity(0.6)),
              );
            } else {
              return Center(
                child: Container(color: Colors.transparent),
              );
            }
          }),
        ],
      ),
    );
  }
}
