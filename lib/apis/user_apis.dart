import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_user.dart';

class UserApis {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseAuth auth = FirebaseAuth.instance;

  static final user = auth.currentUser;

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
    return firestore.collection('users').doc(userId).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFollowings(
      String userId) {
    return firestore
        .collection('followings/$userId/userFollowings/')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFollowers(
      String userId) {
    return firestore.collection('followers/$userId/userFollowers/').snapshots();
  }

  static Future<void> followUser(ChatUser chatUser) async {
    await firestore
        .collection('followings/${user!.uid}/userFollowings/')
        .doc(chatUser.userId)
        .set(
      {'userId': chatUser.userId},
    ).then((value) async {
      await firestore
          .collection('followers/${chatUser.userId}/userFollowers/')
          .doc(user!.uid)
          .set({'userId': user!.uid});
    });
  }

  static Future<void> unfollowUser(ChatUser chatUser) async {
    await firestore
        .collection('followings/${user!.uid}/userFollowings/')
        .doc(chatUser.userId)
        .delete()
        .then((value) async {
      await firestore
          .collection('followers/${chatUser.userId}/userFollowers/')
          .doc(user!.uid)
          .delete();
    });
  }
}
