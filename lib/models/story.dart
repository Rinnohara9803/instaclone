import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/user_apis.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:collection/collection.dart';

enum MediaType { image, video }

class Story with ChangeNotifier {
  Story({
    required this.storyId,
    required this.url,
    required this.media,
    required this.userId,
    required this.viewedBy,
    this.isViewed = false,
  });

  late final int storyId;
  late final String url;
  late final MediaType media;
  late final String userId;
  late final List<UserID> viewedBy;
  late bool isViewed;

  Map<String, dynamic> toJson() => {
        'storyId': storyId,
        'url': url,
        'media': media.index,
        'userId': userId,
        'viewedBy': viewedBy.map((e) => e.toJson()).toList(),
        'isViewed': viewedBy.map((e) => e.toJson()).toList(),
      };

  Story.fromJson(Map<String, dynamic> json) {
    storyId = json['storyId'] ?? 0;
    url = json['url'] ?? '';
    media = MediaType.values[json['media']];
    userId = json['userId'] ?? '';
    viewedBy = List<UserID>.from(
      (json['viewedBy'] ?? []).map(
        (e) => UserID.fromJson(e),
      ),
    );
    isViewed = viewedBy.firstWhereOrNull((element) =>
            element.userId == FirebaseAuth.instance.currentUser!.uid) !=
        null;
  }

  Future<void> updateIsViewed() async {
    try {
      viewedBy.add(UserID(userId: FirebaseAuth.instance.currentUser!.uid));

      await UserApis.firestore
          .collection('stories/$userId/userstories/')
          .doc(storyId.toString())
          .update({
        'viewedBy': viewedBy.map((e) => e.toJson()).toList(),
      }).then((value) {
        isViewed = true;
        notifyListeners();
      }).catchError((e) {
        print(e.toString());
        return;
      });
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}

class UserStory with ChangeNotifier {
  final List<Story> stories;
  final ChatUser user;
  bool isViewedCompletely;

  UserStory({
    required this.stories,
    required this.user,
    this.isViewedCompletely = false,
  }) {
    isViewedCompletely = stories.every((story) => story.isViewed);
  }

  void changeIsViewedStatus() async {
    isViewedCompletely = true;
    notifyListeners();
  }
}
