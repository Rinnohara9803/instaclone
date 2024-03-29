import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';
import 'package:instaclone/presentation/pages/AddMedia/widgets/overlayed_widget.dart';
import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/providers/user_reels_provider.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AddReelsPage extends StatefulWidget {
  final String videoPath;
  const AddReelsPage({super.key, required this.videoPath});

  @override
  State<AddReelsPage> createState() => _AddReelsPageState();
}

class _AddReelsPageState extends State<AddReelsPage> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  final ValueNotifier _showTextField = ValueNotifier(false);
  final List<AdditionalText> _addedTexts = [];
  final List<Widget> _addedWidgets = [];

  bool _showDeleteButton = false;
  bool _isDeleteButtonActive = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.videoPath),
    );
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.play();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.small(
                          backgroundColor:
                              const Color.fromARGB(255, 65, 64, 64),
                          child: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FloatingActionButton.small(
                          backgroundColor:
                              const Color.fromARGB(255, 65, 64, 64),
                          child: const Icon(
                            Icons.text_fields_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (!_isLoading) {
                              _showTextField.value = !_showTextField.value;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
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
                                return Center(
                                  child: AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(
                                      _controller!,
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.grey,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {},
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                            ),
                          ),
                        ),
                        for (var i = 0; i < _addedWidgets.length; i++)
                          Positioned.fill(child: _addedWidgets[i]),
                        ValueListenableBuilder(
                          valueListenable: _showTextField,
                          builder: (context, value, _) {
                            if (value == true) {
                              return TextFormField(
                                autofocus: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {},
                                onFieldSubmitted: (value) {
                                  _showTextField.value = false;
                                  final theText = AdditionalText(
                                    id: DateTime.now().toIso8601String(),
                                    text: value,
                                    offset: const Offset(0, 0),
                                  );
                                  _addedTexts.add(theText);
                                  setState(() {
                                    _addedWidgets.add(
                                      OverlayedWidget(
                                        key: Key(theText.id),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDragStart: () {
                                          if (!_showDeleteButton) {
                                            setState(() {
                                              _showDeleteButton = true;
                                            });
                                          }
                                        },
                                        onDragEnd: (offset, key) {
                                          if (_showDeleteButton) {
                                            setState(() {
                                              _showDeleteButton = false;
                                            });
                                          }

                                          if (offset.dy >
                                              (MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2))) {
                                            setState(() {
                                              _addedWidgets.removeWhere(
                                                  (element) =>
                                                      element.key == key);
                                            });
                                          }
                                        },
                                        onDragUpdate: (offset, key) {
                                          if (offset.dy >
                                              (MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2))) {
                                            if (!_isDeleteButtonActive) {
                                              setState(() {
                                                _isDeleteButtonActive = true;
                                              });
                                            }
                                          } else {
                                            if (_isDeleteButtonActive) {
                                              setState(() {
                                                _isDeleteButtonActive = false;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    );
                                  });
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        if (_showDeleteButton)
                          Positioned(
                            right: 0,
                            left: 0,
                            bottom: 15,
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black38),
                              padding: const EdgeInsets.all(
                                8,
                              ),
                              child: Icon(
                                Icons.delete,
                                size: _isDeleteButtonActive ? 30 : 25,
                                color: _isDeleteButtonActive
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 5,
                        ),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueAccent),
                          ),
                          onPressed: () async {
                            final createdAt =
                                DateTime.now().millisecondsSinceEpoch;
                            final userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await FirebaseStorage.instance
                                  .ref(
                                    'reels/$userId/${widget.videoPath}',
                                  )
                                  .putFile(File(widget.videoPath))
                                  .then((p0) async {
                                String videoUrl = await FirebaseStorage.instance
                                    .ref('reels/$userId/${widget.videoPath}')
                                    .getDownloadURL();

                                await Provider.of<ReelsProvider>(context,
                                        listen: false)
                                    .postReel(
                                  ReelModel(
                                    video: videoUrl,
                                    location: 'test',
                                    caption: '',
                                    id: createdAt.toString(),
                                    createdAt: createdAt,
                                    likes: [],
                                    bookmarks: [],
                                    userId: userId,
                                  ),
                                )
                                    .then((value) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      InitialPage.routename, (route) => false);
                                  SnackBars.showNormalSnackbar(
                                      context, 'Your reel has been posted.');
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              });
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              SnackBars.showErrorSnackBar(
                                  context, e.toString());
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isLoading)
                Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black45,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalText {
  final String id;
  final String text;
  Offset offset;

  AdditionalText({required this.id, required this.text, required this.offset});
}
