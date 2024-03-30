import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/presentation/pages/AddMedia/edit_story_page.dart';
import 'package:instaclone/presentation/pages/AddMedia/widgets/circle_progress.dart';

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

  bool _isLoading = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController.value.isInitialized) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: CameraPreview(
                        _cameraController,
                      ),
                    ),
                  ],
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
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      _cameraController.setFlashMode(FlashMode.auto);
                    },
                    icon: const Icon(
                      Icons.flash_auto,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: const Color.fromARGB(255, 46, 45, 45),
              child: Center(
                child: TheRecorder(
                  cameraController: _cameraController,
                  mounted: mounted,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

// Positioned(
//             top: 5,
//             right: 5,
//             left: 5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 FloatingActionButton.small(
//                   backgroundColor: const Color.fromARGB(255, 65, 64, 64),
//                   child: const Icon(
//                     Icons.clear,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 FloatingActionButton.small(
//                   backgroundColor: const Color.fromARGB(255, 65, 64, 64),
//                   child: const Icon(
//                     Icons.settings,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),

//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 5,
//             child: TheRecorder(
//               cameraController: _cameraController,
//               mounted: mounted,
//             ),
//           ),

class TheRecorder extends StatefulWidget {
  const TheRecorder({
    super.key,
    required CameraController cameraController,
    required this.mounted,
  }) : _cameraController = cameraController;

  final CameraController _cameraController;
  final bool mounted;

  @override
  State<TheRecorder> createState() => _TheRecorderState();
}

class _TheRecorderState extends State<TheRecorder>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late AnimationController _sizeAnimationController;
  late Animation<double> _innerAnimation;
  late Animation<double> _middleAnimation;
  late Animation<double> _outerAnimation;

  @override
  void initState() {
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _outerAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(
        parent: _sizeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _middleAnimation = Tween<double>(begin: 1, end: 1.25).animate(
      CurvedAnimation(
        parent: _sizeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _innerAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _sizeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 30,
      ),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _sizeAnimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _sizeAnimationController,
          builder: (context, child) {
            return CustomPaint(
              foregroundPainter: CircleProgress(_animation.value),
              child: SizedBox(
                height: 85 * _outerAnimation.value,
                width: 85 * _outerAnimation.value,
                child: Center(
                  child: GestureDetector(
                    onLongPressStart: (details) {
                      _sizeAnimationController.forward();
                      _animationController.forward();
                      widget._cameraController.startVideoRecording();
                    },
                    onLongPressEnd: (_) {
                      _sizeAnimationController.reverse();
                      _animationController.reset();
                      widget._cameraController
                          .stopVideoRecording()
                          .then((XFile? file) {
                        if (widget.mounted) {
                          if (file != null) {
                            print("Video saved to ${file.path}");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditStoryPage(
                                    mediaType: MediaType.video,
                                    path: file.path),
                              ),
                            );
                          }
                        }
                      });
                    },
                    onLongPressCancel: () {
                      _animationController.reverse();
                    },
                    onTap: () {
                      widget._cameraController
                          .takePicture()
                          .then((XFile? file) {
                        if (widget.mounted) {
                          if (file != null) {
                            print("Picture saved to ${file.path}");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditStoryPage(
                                    mediaType: MediaType.image,
                                    path: file.path),
                              ),
                            );
                          }
                        }
                      });
                    },
                    child: Container(
                      height: 73 * _middleAnimation.value,
                      width: 73 * _middleAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          height: 60 * _innerAnimation.value,
                          width: 60 * _innerAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
