import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/presentation/pages/AddMedia/edit_story_page.dart';
import 'package:instaclone/presentation/pages/AddMedia/widgets/circle_progress.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_selected_picture_page.dart';

class ClickProfilePicture extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ClickProfilePicture({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _ClickProfilePictureState createState() => _ClickProfilePictureState();
}

class _ClickProfilePictureState extends State<ClickProfilePicture> {
  late CameraController _cameraController;

  int direction = 0;
  ValueNotifier _isFlashModeOn = ValueNotifier<bool>(false);

  @override
  void initState() {
    startCamera(direction);
    super.initState();
  }

  void startCamera(int direction) async {
    _cameraController = CameraController(
      widget.cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void dispose() {
    // Dispose of the camera controller when not needed
    _cameraController.dispose();
    _isFlashModeOn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_cameraController.value.isInitialized) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    direction = direction == 0 ? 1 : 0;
                    startCamera(direction);
                  });
                },
                child: CameraPreview(
                  _cameraController,
                ),
              ),
              Positioned(
                bottom: 5,
                left: 5,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      direction = direction == 0 ? 1 : 0;
                      startCamera(direction);
                    });
                  },
                  icon: const Icon(
                    Icons.flip_camera_android,
                    color: Colors.white,
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _isFlashModeOn,
                  builder: (context, value, child) {
                    return Positioned(
                      bottom: 5,
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          if (value) {
                            _isFlashModeOn.value = false;
                            _cameraController.setFlashMode(FlashMode.off);
                          } else {
                            _isFlashModeOn.value = true;
                            _cameraController.setFlashMode(FlashMode.auto);
                          }
                        },
                        icon: Icon(
                          value ? Icons.flash_off : Icons.flash_auto,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: const Color.fromARGB(255, 46, 45, 45),
            child: Center(
              child: PhotoClickerWidget(
                cameraController: _cameraController,
                mounted: mounted,
              ),
            ),
          ),
        ),
      ],
    );
    // } else {
    //   return const SizedBox();
    // }
  }
}

class PhotoClickerWidget extends StatefulWidget {
  const PhotoClickerWidget({
    super.key,
    required CameraController cameraController,
    required this.mounted,
  }) : _cameraController = cameraController;

  final CameraController _cameraController;
  final bool mounted;

  @override
  State<PhotoClickerWidget> createState() => _PhotoClickerWidgetState();
}

class _PhotoClickerWidgetState extends State<PhotoClickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget._cameraController.takePicture().then((XFile? file) {
              if (widget.mounted) {
                if (file != null) {
                  print("Picture saved to ${file.path}");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditSelectedPicturePage(
                        path: file.path,
                      ),
                    ),
                  );
                }
              }
            });
          },
          child: Container(
            height: 73,
            width: 73,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
