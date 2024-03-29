import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPostsProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  List<UserPostModel> _userPosts = [];

  List<UserPostModel> get userPosts {
    return [..._userPosts];
  }

  List<UserPostModel> _allUserPosts = [];

  List<UserPostModel> get allUserPosts {
    return [..._allUserPosts];
  }

  List<UserPostModel> _latestPosts = [];

  List<UserPostModel> get latestPosts {
    return [..._latestPosts];
  }

  // upload post to database
  Future<void> addPost(UserPostModel userPostModel) async {
    try {
      await firestore.collection('posts/').doc(userPostModel.id).set(
            userPostModel.toJson(),
          );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // fetch posts with user's id
  Future<void> fetchAllPostsOfUserWithLimit(
      String userId, int limitValue) async {
    try {
      List<UserPostModel> listOfPosts = [];
      await firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('id', descending: true)
          .limit(
            limitValue,
          )
          .get()
          .then((data) {
        for (var i in data.docs) {
          listOfPosts.add(
            UserPostModel.fromJson(
              i.data(),
            ),
          );
        }
      });
      _userPosts = listOfPosts;
      notifyListeners();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchAllPostsOfUser(String userId) async {
    try {
      List<UserPostModel> listOfPosts = [];
      await firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('id', descending: true)
          .get()
          .then((data) {
        for (var i in data.docs) {
          listOfPosts.add(
            UserPostModel.fromJson(
              i.data(),
            ),
          );
        }
      });
      _allUserPosts = listOfPosts;
      notifyListeners();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchLatestPosts() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      List<UserPostModel> listOfPosts = [];
      List<String> followingsIds = [];
      await firestore
          .collection('followings/$userId/userFollowings/')
          .get()
          .then((data) {
        for (var i in data.docs) {
          followingsIds.add(i.data()['userId']);
        }
      }).then((value) async {
        await firestore
            .collection('posts')
            .where('userId', whereIn: followingsIds)
            .orderBy('id', descending: true)
            .get()
            .then((data) {
          for (var i in data.docs) {
            listOfPosts.add(
              UserPostModel.fromJson(
                i.data(),
              ),
            );
          }
        });
      });
      _latestPosts = listOfPosts;
      notifyListeners();
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
