import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  late ChatUser _chatUser;

  ChatUser get chatUser => _chatUser;
  Future<void> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then(
        (data) {
          _chatUser = ChatUser.fromJson(data.data() as Map<String, dynamic>);
          notifyListeners();
        },
      );
    } catch (e) {
      return Future.error(
        e.toString(),
      );
    }
  }
}
