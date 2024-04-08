import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';
import 'package:instaclone/models/user_post.dart';

class ReelsProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  List<UserPostModel> _userReels = [];
  List<UserPostModel> _allUserReels = [];
  List<UserPostModel> _latestReels = [];

  List<UserPostModel> get userReels {
    return [..._userReels];
  }

  List<UserPostModel> get allUserReels {
    return [..._allUserReels];
  }

  List<UserPostModel> get latestReels {
    return [..._latestReels];
  }

  Future<void> postReel(UserPostModel reel) async {
    try {
      await firestore.collection('posts/').doc(reel.id).set(
            reel.toJson(),
          );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchAllReelsOfUserWithLimit(
      String userId, int limitValue) async {
    print('fetching user reels');
    try {
      List<UserPostModel> listOfReels = [];
      await firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .where('postType', isEqualTo: 'reel')
          .orderBy('id', descending: true)
          .limit(
            limitValue,
          )
          .get()
          .then((data) {
        if (data.docs.isEmpty) {
          return;
        } else {
          for (var i in data.docs) {
            listOfReels.add(
              UserPostModel.fromJson(
                i.data(),
              ),
            );
          }
        }
      });
      _userReels = listOfReels;
      notifyListeners();
      print(_userReels.length);
    } catch (e) {
      print('error fetching user reels');
      print(e.toString());
      return Future.error(e.toString());
    }
  }

  // Future<void> fetchAllReelsOfUser(String userId) async {
  //   print('here');
  //   try {
  //     List<ReelModel> listOfReels = [];
  //     await firestore
  //         .collection('reels')
  //         .where('userId', isEqualTo: userId)
  //         .orderBy('createdAt', descending: true)
  //         .get()
  //         .then((data) {
  //       for (var i in data.docs) {
  //         listOfReels.add(
  //           ReelModel.fromJson(
  //             i.data(),
  //           ),
  //         );
  //       }
  //     });
  //     _allUserReels = listOfReels;
  //     notifyListeners();
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  Future<void> fetchLatestReels() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      List<UserPostModel> listOfReels = [];
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
            .where('postType', isEqualTo: 'reel')
            .orderBy('id', descending: true)
            .get()
            .then((data) {
          if (data.docs.isEmpty) {
            return;
          } else {
            for (var i in data.docs) {
              listOfReels.add(
                UserPostModel.fromJson(
                  i.data(),
                ),
              );
            }
          }
        });
      });
      _latestReels = listOfReels;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }
}
