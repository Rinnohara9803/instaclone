import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/reel_modal.dart';

class ReelsProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  List<ReelModel> _userReels = [];
  List<ReelModel> _allUserReels = [];
  List<ReelModel> _latestReels = [];

  List<ReelModel> get userReels {
    return [..._userReels];
  }

  List<ReelModel> get allUserReels {
    return [..._allUserReels];
  }

  List<ReelModel> get latestReels {
    return [..._latestReels];
  }

  Future<void> postReel(ReelModel reel) async {
    try {
      await firestore.collection('reels/').doc(reel.id).set(
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
      List<ReelModel> listOfReels = [];
      await firestore
          .collection('reels')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(
            limitValue,
          )
          .get()
          .then((data) {
        for (var i in data.docs) {
          listOfReels.add(
            ReelModel.fromJson(
              i.data(),
            ),
          );
        }
      });
      _userReels = listOfReels;
      notifyListeners();
      print(_userReels.length);
      print(_userReels[0]);
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
      List<ReelModel> listOfReels = [];
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
            .collection('reels')
            .where('userId', whereIn: followingsIds)
            .orderBy('createdAt', descending: true)
            .get()
            .then((data) {
          for (var i in data.docs) {
            listOfReels.add(
              ReelModel.fromJson(
                i.data(),
              ),
            );
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
