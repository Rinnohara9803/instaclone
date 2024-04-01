import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/video_file_model.dart';
import 'package:instaclone/presentation/pages/AddMedia/add_reels_page.dart';
import 'package:instaclone/presentation/pages/AddMedia/video_reel_widget.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:provider/provider.dart';

class SelectReelsPage extends StatefulWidget {
  final Function navigateBack;
  const SelectReelsPage({super.key, required this.navigateBack});

  @override
  State<SelectReelsPage> createState() => _SelectReelsPageState();
}

class _SelectReelsPageState extends State<SelectReelsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FetchMediasProvider>(context, listen: false).getVideosPath();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
                print('this next button is running');
                return TextButton(
                  onPressed: () {
                    if (fmp.selectedVideo == null) {
                      return;
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddReelsPage(
                            videoPath: fmp.selectedVideo!.path,
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
        Consumer<FetchMediasProvider>(builder: (context, fmp, child) {
          print('this dropdown is running');
          if (fmp.videoFileFolders.isEmpty) {
            return const SizedBox();
          } else {
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
                      },
                      value: fmp.selectedVideoFileModel,
                      dropdownColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.white
                              : const Color.fromARGB(255, 72, 71, 71),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
        Selector<FetchMediasProvider, VideoFileModel?>(
          selector: (ctx, provider) => provider.selectedVideoFileModel,
          builder: (ctx, selectedVideoFileModel, child) {
            print('this mf is running');

            if (selectedVideoFileModel == null) {
              return Container();
            } else {
              return Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (_, i) {
                    var file = selectedVideoFileModel.files[i];

                    return VideoReelWidget(
                      videoFile: file,
                    );
                  },
                  itemCount: selectedVideoFileModel.files.length,
                ),
              );
            }
          },
        )
      ],
    );
  }
}
