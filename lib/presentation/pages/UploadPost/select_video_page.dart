import 'package:flutter/material.dart';
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
  @override
  void initState() {
    Provider.of<FetchMediasProvider>(context, listen: false)
        .initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    widget.navigateBack();
                  },
                ),
                Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                  return TextButton(
                    onPressed: () {
                      fmp.controller!.pause();
                      if (fmp.selectedMedias.isEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AddPostDetailsPage(
                              medias: [fmp.selectedVideo],
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AddPostDetailsPage(
                              medias: fmp.selectedMedias,
                            ),
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
                          if (fmp.controller!.value.isPlaying) {
                            fmp.controller!.pause();
                          } else {
                            fmp.controller!.play();
                          }
                        },
                        child: FutureBuilder(
                          future: fmp.initializaeVideoPlayerFuture,
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
                                aspectRatio: fmp.controller!.value.aspectRatio,
                                child: VideoPlayer(
                                  fmp.controller!,
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
                        fmp.initializeController();
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
                      fmp.selectMultipleMedias
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
                                  border: Border.all(
                                    color: Theme.of(context).errorColor,
                                  ),
                                  color: Colors.blueAccent,
                                ),
                                child: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                fmp.toggleSelectMultipleImages();
                                fmp.setCurrentVideo();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  7,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).errorColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            ),
                      IconButton(
                        onPressed: () {
                          widget.setImages();
                          Provider.of<FetchMediasProvider>(
                            context,
                            listen: false,
                          ).disposeController();
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
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
