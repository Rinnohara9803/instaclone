import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  late ChatUser _chatUser;

  ChatUser get chatUser => _chatUser;

  bool _loadingState = false;

  bool get loadingState {
    return _loadingState;
  }

  // late ChatUser _theUser;

  // ChatUser get theUser => _theUser;

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

  // Future<void> fetchUserProfile(String userId) async {
  //   _theUser = ChatUser(
  //     createdAt: 'createdAt',
  //     lastActive: 'lastActive',
  //     isOnline: false,
  //     profileImage: 'profileImage',
  //     userName: 'User',
  //     pushToken: 'pushToken',
  //     userId: userId,
  //     email: '',
  //     bio: '',
  //     gender: '',
  //   );
  //   notifyListeners();
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get()
  //         .then(
  //       (data) {
  //         _theUser = ChatUser.fromJson(data.data() as Map<String, dynamic>);
  //         notifyListeners();
  //       },
  //     );
  //   } catch (e) {
  //     return Future.error(
  //       e.toString(),
  //     );
  //   }
  // }

  Future<void> editProfileImage(String imagePath) async {
    _loadingState = true;
    notifyListeners();
    try {
      await FirebaseStorage.instance
          .ref(
            'profileImages/${chatUser.userId}/$imagePath',
          )
          .putFile(File(imagePath))
          .then((p0) {});

      String imageUrl = await FirebaseStorage.instance
          .ref('profileImages/${chatUser.userId}/$imagePath')
          .getDownloadURL();
      await firestore.collection('users').doc(chatUser.userId).update({
        'profileImage': imageUrl,
      }).then((value) {
        _chatUser = ChatUser.fromJson({
          ..._chatUser.toJson(),
          'profileImage': imageUrl,
        });
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
    _loadingState = false;
    notifyListeners();
  }

  Future<void> editUserName(String userName) async {
    _loadingState = true;
    notifyListeners();
    try {
      await firestore.collection('users').doc(chatUser.userId).update({
        'userName': userName,
      }).then((value) {
        _chatUser = ChatUser.fromJson({
          ..._chatUser.toJson(),
          'userName': userName,
        });
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
    _loadingState = false;
    notifyListeners();
  }

  Future<void> editBio(String bio) async {
    _loadingState = true;
    notifyListeners();
    try {
      await firestore.collection('users').doc(chatUser.userId).update({
        'bio': bio,
      }).then((value) {
        _chatUser = ChatUser.fromJson({
          ..._chatUser.toJson(),
          'bio': bio,
        });
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
    _loadingState = false;
    notifyListeners();
  }

  Future<void> editGender(String gender) async {
    _loadingState = true;
    notifyListeners();
    try {
      await firestore.collection('users').doc(chatUser.userId).update({
        'gender': gender,
      }).then((value) {
        _chatUser = ChatUser.fromJson({
          ..._chatUser.toJson(),
          'gender': gender,
        });
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
    _loadingState = false;
    notifyListeners();
  }

  Future<void> removeProfilePicture() async {
    _loadingState = true;
    notifyListeners();
    try {
      await firestore.collection('users').doc(chatUser.userId).update({
        'profileImage': null,
      }).then((value) {
        _chatUser = ChatUser.fromJson({
          ..._chatUser.toJson(),
          'profileImage': '',
        });
        notifyListeners();
      });
    } catch (e) {
      return Future.error(e.toString());
    }
    _loadingState = false;
    notifyListeners();
  }
}
