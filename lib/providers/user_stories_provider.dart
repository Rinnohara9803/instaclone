import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/models/story.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class UserStoriesProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;

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

  DateTime getADayAgoTimestamp() {
    return DateTime.now().subtract(
      const Duration(
        hours: 24,
      ),
    );
  }

  Future<void> fetchUserStory(String userId) async {
    try {
      List<Story> listOfStories = [];
      final aDayAgoTimestamp = getADayAgoTimestamp();
      await firestore
          .collection('stories/$userId/userstories/')
          .where(
            'storyId',
            isGreaterThan: aDayAgoTimestamp.millisecondsSinceEpoch,
          )
          .orderBy('storyId', descending: true)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty) {
          for (var i in data.docs) {
            listOfStories.add(
              Story.fromJson(
                i.data(),
              ),
            );
          }
        } else {}
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
                final theStory =
                    UserStory(stories: listOfStories, user: chatUser);
                if (theStory.isViewedCompletely) {
                  _followingsStories.add(theStory);
                  notifyListeners();
                } else {
                  _followingsStories.insert(0, theStory);
                  notifyListeners();
                }
              },
            );
          }
        } else {
          return;
        }
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchFollowingsStories() async {
    final user = FirebaseAuth.instance.currentUser;

    _followingsStories = [];
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('followings/${user!.uid}/userFollowings')
          .get()
          .then((snapshot) async {
        _followingsList = [];
        // _followingsList.add(user!.uid);
        for (var i in snapshot.docs) {
          _followingsList.add(i.data()['userId']);
        }
        if (_followingsList.isNotEmpty) {
          for (var userId in _followingsList) {
            await fetchUserStory(userId).then((value) {});
          }
        }
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchMyStory(String userId) async {
    // _myStory = null;
    // notifyListeners();

    try {
      List<Story> listOfStories = [];
      final aDayAgoTimestamp = getADayAgoTimestamp();
      await firestore
          .collection('stories/$userId/userstories/')
          .where(
            'storyId',
            isGreaterThan: aDayAgoTimestamp.millisecondsSinceEpoch,
          )
          .orderBy('storyId', descending: true)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty) {
          for (var i in data.docs) {
            listOfStories.add(
              Story.fromJson(
                i.data(),
              ),
            );
          }
        } else {
          _myStory = null;
          notifyListeners();
        }
      }).then((value) async {
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
              print(_myStory?.user.userName);
              notifyListeners();
              _followingsStories.insert(0, _myStory!);
              notifyListeners();
            },
          );
        }
      });
    } catch (e) {
      _myStory = null;
      notifyListeners();
    }
  }

  Future<void> addStory(mediaType, mediaPath) async {
    final storyId = DateTime.now().millisecondsSinceEpoch;
    final user = FirebaseAuth.instance.currentUser;

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
