import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/comment.dart';

class CommentsProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;

  List<Comment> _comments = [];
  List<Comment> get comments {
    return [..._comments];
  }

  Comment? _selectedComment;

  Comment? get selectedComment {
    return _selectedComment;
  }

  void setSelectedComment(Comment? comment) {
    if (comment == null) {
      _selectedComment = null;
      notifyListeners();
    } else if (selectedComment != null && comment.id == _selectedComment!.id) {
      _selectedComment = null;
      notifyListeners();
    } else {
      _selectedComment = comment;
      notifyListeners();
    }
  }

  Future<void> postComment(String postId, String comment) async {
    final user = FirebaseAuth.instance.currentUser;
    final createdAt = DateTime.now();
    final commentId = createdAt.millisecondsSinceEpoch.toString();
    final theComment = Comment(
      id: commentId,
      postId: postId,
      comment: comment,
      createdAt: createdAt,
      likedBy: [],
      userId: user!.uid,
    );
    try {
      await firestore
          .collection('comments/$postId/postComments')
          .doc(commentId)
          .set(theComment.toJson())
          .then((value) {
        _comments = [theComment, ..._comments];
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> postReplyToComment(
      String postId, String theCommentId, String reply) async {
    final user = FirebaseAuth.instance.currentUser;
    final createdAt = DateTime.now();
    final commentId = createdAt.millisecondsSinceEpoch.toString();
    final theComment = Comment(
      id: commentId,
      postId: postId,
      comment: reply,
      createdAt: createdAt,
      likedBy: [],
      userId: user!.uid,
    );
    try {
      await firestore
          .collection('comments/$postId/postComments/$theCommentId/replies')
          .doc(commentId)
          .set(theComment.toJson())
          .then((value) {
        // _comments = [theComment, ..._comments];
        // notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchCommentsWithLimit(String postId, int limitValue) async {
    try {
      List<Comment> listOfComments = [];
      await firestore
          .collection('comments/$postId/postComments')
          .orderBy('id', descending: true)
          .limit(
            limitValue,
          )
          .get()
          .then((data) {
        if (data.docs.isEmpty) {
          _comments = [];
          notifyListeners();
        } else {
          for (var i in data.docs) {
            listOfComments.add(
              Comment.fromJson(
                i.data(),
              ),
            );
          }
          _comments = listOfComments;
          notifyListeners();
        }
      });
    } catch (e) {
      _comments = [];
      notifyListeners();
      return Future.error(e.toString());
    }
  }

  Future<void> deleteComment(Comment comment) async {
    try {
      await firestore
          .collection('comments/${comment.postId}/postComments')
          .doc(comment.id)
          .delete()
          .then((value) {
        _comments.removeWhere((element) => element.id == comment.id);
        notifyListeners();
        _selectedComment = null;
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
