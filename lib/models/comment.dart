import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:instaclone/apis/user_apis.dart';

class Comment with ChangeNotifier {
  late String id;
  late String postId;
  late String comment;
  late DateTime createdAt;
  late List<String> likedBy;
  late String userId;
  late bool isLikedByMe;

  Comment({
    required this.id,
    required this.postId,
    required this.comment,
    required this.createdAt,
    required this.likedBy,
    required this.userId,
    this.isLikedByMe = false,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    final user = FirebaseAuth.instance.currentUser;
    id = json['id'];
    postId = json['postId'];
    comment = json['comment'];
    createdAt = DateTime.parse(json['createdAt']);
    likedBy = List<String>.from(json['likedBy']);
    userId = json['userId'];
    isLikedByMe =
        likedBy.firstWhereOrNull((userId) => userId == user!.uid) != null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'likedBy': likedBy,
      'userId': userId,
      'isLikedByMe': isLikedByMe,
    };
  }

  Future<void> toggleIsLikedByMeForReplye(String theCommentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (!isLikedByMe) {
      isLikedByMe = true;
      notifyListeners();

      likedBy.add(user!.uid);
      await UserApis.firestore
          .collection('comments/$postId/postComments/$theCommentId/replies')
          .doc(id)
          .update({
            'likedBy': likedBy.map((e) => e).toList(),
          })
          .then((value) {})
          .catchError((e) {
            isLikedByMe = false;
            notifyListeners();
          });
    } else {
      isLikedByMe = false;
      notifyListeners();
      likedBy.removeWhere((element) => element == user!.uid);
      await UserApis.firestore
          .collection('comments/$postId/postComments/$theCommentId/replies')
          .doc(id)
          .update(
            {
              'likedBy': likedBy.map((e) => e).toList(),
            },
          )
          .then((value) {})
          .catchError((e) {
            isLikedByMe = true;
            notifyListeners();
          });
    }
  }

  Future<void> toggleIsLikedByMe() async {
    final user = FirebaseAuth.instance.currentUser;
    if (!isLikedByMe) {
      isLikedByMe = true;
      notifyListeners();

      likedBy.add(user!.uid);
      await UserApis.firestore
          .collection('comments/$postId/postComments')
          .doc(id)
          .update({
            'likedBy': likedBy.map((e) => e).toList(),
          })
          .then((value) {})
          .catchError((e) {
            isLikedByMe = false;
            notifyListeners();
          });
    } else {
      isLikedByMe = false;
      notifyListeners();
      likedBy.removeWhere((element) => element == user!.uid);
      await UserApis.firestore
          .collection('comments/$postId/postComments')
          .doc(id)
          .update(
            {
              'likedBy': likedBy.map((e) => e).toList(),
            },
          )
          .then((value) {})
          .catchError((e) {
            isLikedByMe = true;
            notifyListeners();
          });
    }
  }
}
