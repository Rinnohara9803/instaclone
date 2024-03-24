import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/models/story.dart';

class UserStoriesProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  List<String> _followingsList = [];

  List<String> get followingsList {
    return [..._followingsList];
  }

  UserStory? _myStory;

  UserStory? get myStory {
    return _myStory;
  }

  List<UserStory> _followingsStories = [];

  List<UserStory> get followingsStories {
    return [..._followingsStories];
  }

  DateTime getOneHourAgoTimestamp() {
    return DateTime.now().subtract(
      const Duration(
        hours: 10,
      ),
    );
  }

  Future<void> fetchUserStory(String userId) async {
    try {
      List<Story> listOfStories = [];
      final oneHourAgoTimestamp = getOneHourAgoTimestamp();

      await firestore
          .collection('stories/$userId/userstories/')
          .where(
            'storyId',
            isGreaterThan: oneHourAgoTimestamp.microsecondsSinceEpoch,
          )
          // .orderBy('storyId', descending: true)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty) {
          print(userId + ' yes data');
          for (var i in data.docs) {
            listOfStories.add(
              Story.fromJson(
                i.data(),
              ),
            );
          }
        } else {
          print(userId + ' no data');
        }
      }).then((value) async {
        if (listOfStories.isNotEmpty) {
          if (listOfStories.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get()
                .then(
              (data) {
                ChatUser chatUser =
                    ChatUser.fromJson(data.data() as Map<String, dynamic>);
                _myStory = UserStory(stories: listOfStories, user: chatUser);
                _followingsStories.add(_myStory!);
                notifyListeners();
              },
            );
          }
        } else {
          _followingsStories = [];
          notifyListeners();
        }
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchFollowingsStories() async {
    _followingsStories = [];
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('followings/${user!.uid}/userFollowings')
          .get()
          .then((snapshot) async {
        _followingsList = [];
        for (var i in snapshot.docs) {
          _followingsList.add(i.data()['userId']);
        }
        if (_followingsList.isNotEmpty) {
          for (var userId in _followingsList) {
            await fetchUserStory(userId).then((value) {});
          }
        }
      });
      for (var i in _followingsStories) {
        print(i.stories.length);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> addStory(mediaType, mediaPath) async {
    final storyId = DateTime.now().millisecondsSinceEpoch;
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
          .doc(storyId.toString())
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
