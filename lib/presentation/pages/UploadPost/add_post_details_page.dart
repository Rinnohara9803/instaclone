import 'dart:io';
import 'package:instaclone/apis/maps_apis.dart';
import 'package:instaclone/apis/user_apis.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/models/video_file_model.dart';

import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/add_location_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';

import 'package:instaclone/utilities/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../providers/user_posts_provider.dart';
import 'apply_filters_page.dart';

class AddPostDetailsPage extends StatefulWidget {
  final List<Files> videos;
  final List<ImageFilterFile> images;
  const AddPostDetailsPage(
      {super.key, required this.images, required this.videos});

  @override
  State<AddPostDetailsPage> createState() => _AddPostDetailsPageState();
}

class _AddPostDetailsPageState extends State<AddPostDetailsPage> {
  final _captionController = TextEditingController();
  String theLocation = '';

  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  void setLocation(String location) {
    print('here' + location);
    setState(() {
      theLocation = location;
    });
  }

  bool _isLoading = false;
  List<Images> imageUrls = [];
  List<String> videoUrls = [];

  Future<void> getImageUrls() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    try {
      if (widget.images.isEmpty) {
        print('post videos');
        for (var video in widget.videos) {
          await FirebaseStorage.instance
              .ref(
                'posts/$userId/${video.path}',
              )
              .putFile(File(video.path))
              .then((p0) {});

          String videoUrl = await FirebaseStorage.instance
              .ref('posts/$userId/${video.path}')
              .getDownloadURL();
          videoUrls.add(videoUrl);
        }
      } else {
        for (var image in widget.images) {
          await FirebaseStorage.instance
              .ref(
                'posts/$userId/${image.id}',
              )
              .putFile(File(image.id))
              .then((p0) {});

          String imageUrl = await FirebaseStorage.instance
              .ref('posts/$userId/${image.id}')
              .getDownloadURL();
          imageUrls.add(
            Images(
              imageUrl: imageUrl,
              filterName: image.colorFilterModel.filterName,
            ),
          );
        }
      }
    } catch (e) {
      SnackBars.showErrorSnackBar(context, e.toString());
    }
  }

  Future<void> uploadPost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final postId = DateTime.now().millisecondsSinceEpoch.toString();
      await getImageUrls().then((value) {
        Provider.of<UserPostsProvider>(context, listen: false).addPost(
          UserPostModel(
            id: postId,
            images: imageUrls,
            videos: videoUrls,
            likes: [],
            bookmarks: [],
            caption: _captionController.text,
            userId: UserApis.user!.uid,
            location: theLocation,
          ),
        );
      });

      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil(InitialPage.routename, (route) => false);
      SnackBars.showNormalSnackbar(context, 'Post upload successful.');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      SnackBars.showErrorSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    if (widget.videos.isNotEmpty) {
      _controller?.dispose();
      _controller = VideoPlayerController.file(
        File(widget.videos[0].path),
      );
      _initializeVideoPlayerFuture = _controller!.initialize();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (var i in widget.images) {
      print(i.colorFilterModel.filterName);
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBar(),
                    Row(
                      children: [
                        if (widget.images.isNotEmpty)
                          Stack(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.file(
                                  File(widget.images[0].id),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (widget.images.length > 1)
                                const Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.folder_copy_sharp,
                                  ),
                                ),
                            ],
                          ),
                        if (widget.videos.isNotEmpty)
                          Stack(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: VideoPlayer(_controller!),
                              ),
                              if (widget.videos.length > 1)
                                const Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.folder_copy_sharp,
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: _captionController,
                            cursorColor: Colors.blue,
                            style: Theme.of(context).textTheme.bodySmall,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              fillColor: Provider.of<ThemeProvider>(context)
                                      .isLightTheme
                                  ? Colors.transparent
                                  : null,
                              filled: true,
                              hintText: 'Write a caption...',
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBoxConstants.sizedboxh5,
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        GoogleMapsApis.determinePosition().then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SetLocationPage(
                                setPostLocation: setLocation,
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }).catchError((e) {
                          SnackBars.showErrorSnackBar(
                              context, 'Something went wrong.');
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        width: double.infinity,
                        child: const Text(
                          'Add Location',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 0,
                    ),
                    if (theLocation.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              theLocation,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setLocation('');
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    if (theLocation.isNotEmpty)
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 0,
                      ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
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
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            const Text(
              'New Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            await uploadPost();
          },
          icon: const Icon(
            Icons.arrow_forward_outlined,
          ),
        ),
      ],
    );
  }
}
