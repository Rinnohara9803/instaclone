import 'dart:io';
import 'package:instaclone/apis/maps_apis.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:instaclone/models/video_file_model.dart';

import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/add_location_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';

import 'package:instaclone/utilities/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';
import '../../../providers/user_posts_provider.dart';

class AddPostDetailsPage extends StatefulWidget {
  final List<dynamic> medias;

  const AddPostDetailsPage({
    super.key,
    required this.medias,
  });

  @override
  State<AddPostDetailsPage> createState() => _AddPostDetailsPageState();
}

class _AddPostDetailsPageState extends State<AddPostDetailsPage> {
  final _captionController = TextEditingController();
  String theLocation = '';
  List<Media> medias = [];

  void setLocation(String location) {
    setState(() {
      theLocation = location;
    });
  }

  bool _isLoading = false;

  Future<void> getImageUrls() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    try {
      for (var media in widget.medias) {
        if (media is String) {
          await FirebaseStorage.instance
              .ref(
                'posts/$userId/$media',
              )
              .putFile(File(media))
              .then((p0) {});

          String imageUrl = await FirebaseStorage.instance
              .ref('posts/$userId/$media')
              .getDownloadURL();
          medias.add(Media(type: MediaType.image, url: imageUrl));
        } else {
          await FirebaseStorage.instance
              .ref(
                'posts/$userId/${media.path}',
              )
              .putFile(File(media.path))
              .then((p0) {});

          String videoURl = await FirebaseStorage.instance
              .ref('posts/$userId/${media.path}')
              .getDownloadURL();
          medias.add(Media(type: MediaType.video, url: videoURl));
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
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await getImageUrls().then((value) {
        Provider.of<UserPostsProvider>(context, listen: false).addPost(
          UserPostModel(
            id: postId,
            medias: medias,
            likes: [],
            bookmarks: [],
            caption: _captionController.text,
            userId: userId,
            location: theLocation,
          ),
        );
      });

      setState(() {
        _isLoading = false;
      });
      Provider.of<FetchMediasProvider>(context, listen: false)
          .clearSelectedMedias();
      Provider.of<FetchMediasProvider>(context, listen: false)
          .disposeController();
      Provider.of<FetchMediasProvider>(context, listen: false)
          .toggleToSelectOneMedia();
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
    for (var i in widget.medias) {
      print(i is String);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        if (widget.medias.isNotEmpty)
                          Stack(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: widget.medias[0] is String
                                    ? Image(
                                        image: FileImage(
                                          File(
                                            widget.medias[0],
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : VideoThumbnail(
                                        videoFile: widget.medias[0],
                                      ),
                              ),
                              if (widget.medias.length > 1)
                                const Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.content_copy,
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

class VideoThumbnail extends StatelessWidget {
  final Files videoFile;
  const VideoThumbnail({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context) {
    File? thumbnail;

    Future<void> getThumbnail() async {
      await VideoCompress.getFileThumbnail(videoFile.path,
              quality: 50, // default(100)
              position: -1 // default(-1)
              )
          .then((value) {
        thumbnail = value;
      }).catchError((e) {
        print(e.toString());
      });
    }

    return FutureBuilder(
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
    );
  }
}
