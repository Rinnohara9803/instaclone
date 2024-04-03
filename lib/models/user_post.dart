import 'package:flutter/material.dart';
import 'package:instaclone/apis/user_apis.dart';
import 'package:collection/collection.dart';

enum MediaType { image, video }

class Media {
  late final MediaType type;
  late final String url;

  Media({
    required this.type,
    required this.url,
  });

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'] == 'image' ? MediaType.image : MediaType.video;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type == MediaType.image ? 'image' : 'video';
    data['url'] = url;
    return data;
  }
}

class UserPostModel with ChangeNotifier {
  UserPostModel({
    required this.medias,
    required this.location,
    required this.caption,
    required this.id,
    required this.likes,
    required this.bookmarks,
    required this.userId,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  late final List<Media> medias;
  late final String location;
  late final String caption;
  late final String id;
  late final List<UserID> likes;
  late final List<Bookmarks> bookmarks;
  late final String userId;
  late bool isLiked;
  late bool isBookmarked;

  Future<void> toggleIsBookmarked() async {
    if (!isBookmarked) {
      isBookmarked = true;
      notifyListeners();

      bookmarks.add(Bookmarks(userId: UserApis.user!.uid));
      await UserApis.firestore
          .collection('posts')
          .doc(id)
          .update({
            'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
          })
          .then((value) {})
          .catchError((e) {
            isBookmarked = false;
            notifyListeners();
          });
    } else {
      isBookmarked = false;
      notifyListeners();
      bookmarks.removeWhere((element) => element.userId == UserApis.user!.uid);
      await UserApis.firestore
          .collection('posts')
          .doc(id)
          .update(
            {
              'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
            },
          )
          .then((value) {})
          .catchError((e) {
            isBookmarked = true;
            notifyListeners();
          });
    }
  }

  Future<void> toggleIsLiked() async {
    if (!isLiked) {
      isLiked = true;
      notifyListeners();

      likes.add(UserID(userId: UserApis.user!.uid));
      await UserApis.firestore
          .collection('posts')
          .doc(id)
          .update({
            'likes': likes.map((e) => e.toJson()).toList(),
          })
          .then((value) {})
          .catchError((e) {
            isLiked = false;
            notifyListeners();
          });
    } else {
      isLiked = false;
      notifyListeners();
      likes.removeWhere((element) => element.userId == UserApis.user!.uid);
      await UserApis.firestore
          .collection('posts')
          .doc(id)
          .update(
            {
              'likes': likes.map((e) => e.toJson()).toList(),
            },
          )
          .then((value) {})
          .catchError((e) {
            isLiked = true;
            notifyListeners();
          });
    }
  }

  UserPostModel.fromJson(Map<String, dynamic> json) {
    medias = List.from(json['medias']).map((e) => Media.fromJson(e)).toList();
    location = json['location'];
    caption = json['caption'];
    id = json['id'];
    likes = List.from(json['likes']).map((e) => UserID.fromJson(e)).toList();
    bookmarks =
        List.from(json['bookmarks']).map((e) => Bookmarks.fromJson(e)).toList();
    userId = json['userId'];
    isLiked = likes.firstWhereOrNull(
            (element) => element.userId == UserApis.user!.uid) !=
        null;
    isBookmarked = bookmarks.firstWhereOrNull(
            (element) => element.userId == UserApis.user!.uid) !=
        null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['medias'] = medias.map((e) => e.toJson()).toList();
    data['location'] = location;
    data['caption'] = caption;
    data['id'] = id;
    data['likes'] = likes.map((e) => e.toJson()).toList();
    data['bookmarks'] = bookmarks.map((e) => e.toJson()).toList();
    data['userId'] = userId;
    return data;
  }
}

class UserID {
  late final String userId;

  UserID({
    required this.userId,
  });

  UserID.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    return data;
  }
}

class Bookmarks {
  late final String userId;

  Bookmarks({
    required this.userId,
  });

  Bookmarks.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    return data;
  }
}
