import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/story.dart';

class UserStoriesProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  List<Story> _myStories = [];

  List<Story> get myStories {
    return [..._myStories];
  }

  Future<void> fetchMyStory() async {
    try {
      List<Story> listOfStories = [];
      await firestore
          .collection('stories/${user!.uid}/userstories/')
          .orderBy('id', descending: true)
          .get()
          .then((data) {
        for (var i in data.docs) {
          listOfStories.add(
            Story.fromJson(
              i.data(),
            ),
          );
        }
      });
      _myStories = listOfStories;
      notifyListeners();
      print(_myStories);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchFollowingsStories() async {
    try {} catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> addStory(mediaType, mediaPath) async {
    final storyId = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await FirebaseStorage.instance
          .ref(
            'stories/$storyId/$mediaPath',
          )
          .putFile(File(mediaPath))
          .then((p0) {});

      String videoUrl = await FirebaseStorage.instance
          .ref('stories/$storyId/$mediaPath')
          .getDownloadURL();
      await firestore
          .collection('stories/${user!.uid}/userstories/')
          .doc(storyId)
          .set(Story(
            storyId: storyId,
            url: videoUrl,
            media: mediaType,
            userId: user!.uid,
            viewedBy: [],
          ).toJson());
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
