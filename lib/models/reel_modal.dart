// import 'package:flutter/material.dart';
// import 'package:instaclone/apis/user_apis.dart';
// import 'package:collection/collection.dart';

// class ReelModel with ChangeNotifier {
//   ReelModel({
//     required this.video, // Added videos field
//     required this.location,
//     required this.caption,
//     required this.id,
//     required this.createdAt,
//     required this.likes,
//     required this.bookmarks,
//     required this.userId,
//     this.isLiked = false,
//     this.isBookmarked = false,
//   });

//   late final String video; // List of video URLs
//   late final String location;
//   late final String caption;
//   late final String id;
//   late final int createdAt;
//   late final List<UserID> likes;
//   late final List<Bookmarks> bookmarks;
//   late final String userId;
//   late bool isLiked;
//   late bool isBookmarked;

//   Future<void> toggleIsBookmarked() async {
//     if (!isBookmarked) {
//       isBookmarked = true;
//       notifyListeners();

//       bookmarks.add(Bookmarks(userId: UserApis.user!.uid));
//       await UserApis.firestore
//           .collection('reels')
//           .doc(id)
//           .update({
//             'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
//           })
//           .then((value) {})
//           .catchError((e) {
//             isBookmarked = false;
//             notifyListeners();
//           });
//     } else {
//       isBookmarked = false;
//       notifyListeners();
//       bookmarks.removeWhere((element) => element.userId == UserApis.user!.uid);
//       await UserApis.firestore
//           .collection('reels')
//           .doc(id)
//           .update(
//             {
//               'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
//             },
//           )
//           .then((value) {})
//           .catchError((e) {
//             isBookmarked = true;
//             notifyListeners();
//           });
//     }
//   }

//   Future<void> toggleIsLiked() async {
//     if (!isLiked) {
//       isLiked = true;
//       notifyListeners();

//       likes.add(UserID(userId: UserApis.user!.uid));
//       await UserApis.firestore
//           .collection('reels')
//           .doc(id)
//           .update({
//             'likes': likes.map((e) => e.toJson()).toList(),
//           })
//           .then((value) {})
//           .catchError((e) {
//             isLiked = false;
//             notifyListeners();
//           });
//     } else {
//       isLiked = false;
//       notifyListeners();
//       likes.removeWhere((element) => element.userId == UserApis.user!.uid);
//       await UserApis.firestore
//           .collection('reels')
//           .doc(id)
//           .update(
//             {
//               'likes': likes.map((e) => e.toJson()).toList(),
//             },
//           )
//           .then((value) {})
//           .catchError((e) {
//             isLiked = true;
//             notifyListeners();
//           });
//     }
//   }

//   ReelModel.fromJson(Map<String, dynamic> json) {
//     video = json['video']; // Parse videos field
//     location = json['location'];
//     caption = json['caption'];
//     id = json['id'];
//     createdAt = json['createdAt'];
//     likes = List.from(json['likes']).map((e) => UserID.fromJson(e)).toList();
//     bookmarks =
//         List.from(json['bookmarks']).map((e) => Bookmarks.fromJson(e)).toList();
//     userId = json['userId'];
//     isLiked = likes.firstWhereOrNull(
//             (element) => element.userId == UserApis.user!.uid) !=
//         null;
//     isBookmarked = bookmarks.firstWhereOrNull(
//             (element) => element.userId == UserApis.user!.uid) !=
//         null;
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['video'] = video; // Add videos field
//     data['location'] = location;
//     data['caption'] = caption;
//     data['id'] = id;
//     data['createdAt'] = createdAt;
//     data['likes'] = likes.map((e) => e.toJson()).toList();
//     data['bookmarks'] = bookmarks.map((e) => e.toJson()).toList();
//     data['userId'] = userId;
//     return data;
//   }
// }

// class Images {
//   Images({
//     required this.imageUrl,
//     required this.filterName,
//   });
//   late final String imageUrl;
//   late final String filterName;

//   Images.fromJson(Map<String, dynamic> json) {
//     imageUrl = json['imageUrl'];
//     filterName = json['filterName'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['imageUrl'] = imageUrl;
//     data['filterName'] = filterName;
//     return data;
//   }
// }

// class UserID {
//   UserID({
//     required this.userId,
//   });
//   late final String userId;

//   UserID.fromJson(Map<String, dynamic> json) {
//     userId = json['userId'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['userId'] = userId;
//     return data;
//   }
// }

// class Bookmarks {
//   Bookmarks({
//     required this.userId,
//   });
//   late final String userId;

//   Bookmarks.fromJson(Map<String, dynamic> json) {
//     userId = json['userId'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['userId'] = userId;
//     return data;
//   }
// }
