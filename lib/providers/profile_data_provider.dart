import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/apis/user_apis.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:flutter/material.dart';

class ProfileDataProvider with ChangeNotifier {
  int _followings = 0;
  int _followers = 0;

  List<String> _followersList = [];
  List<String> _followingsList = [];

  int get followings => _followings;
  int get followers => _followers;

  List<String> get followersList {
    return [..._followersList];
  }

  List<String> get followingsList {
    return [..._followingsList];
  }

  Future<void> getFollowers(String userId) async {
    await FirebaseFirestore.instance
        .collection('followers/$userId/userFollowers/')
        .get()
        .then((snapshot) {
      _followersList = [];
      notifyListeners();
      for (var i in snapshot.docs) {
        _followersList.add(i.data()['userId']);
      }
      _followers = _followersList.length;
      notifyListeners();
    });
  }

  Future<void> getFollowings(String userId) async {
    await FirebaseFirestore.instance
        .collection('followings/$userId/userFollowings')
        .get()
        .then((snapshot) {
      _followingsList = [];
      notifyListeners();
      for (var i in snapshot.docs) {
        _followingsList.add(i.data()['userId']);
      }
      _followings = _followingsList.length;
      notifyListeners();
    });
  }

  Future<void> follow(ChatUser chatUser) async {
    await UserApis.followUser(chatUser).then((_) {
      _followers += 1;
      notifyListeners();
    });
  }

  Future<void> unfollow(ChatUser chatUser) async {
    await UserApis.unfollowUser(chatUser).then((_) {
      _followers -= 1;
      notifyListeners();
    });
  }
}
