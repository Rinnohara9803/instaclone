import 'package:instaclone/models/chat_user.dart';

enum MediaType { image, video }

class Story {
  final String storyId;
  final String url;
  final MediaType media;
  final String userId;
  final List<String> viewedBy;

  const Story({
    required this.storyId,
    required this.url,
    required this.media,
    required this.userId,
    required this.viewedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'url': url,
      'media': media.index, // Store enum as its index
      'userID': userId, // Assuming ChatUser has toJson method
      'viewedBy': viewedBy,
    };
  }

  // Named constructor to create a Story instance from a Map
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyId: json['storyId'],
      url: json['url'],
      media: MediaType.values[json['media']], // Convert index back to enum
      userId: json['userId'], // Assuming ChatUser has fromJson method
      viewedBy: List<String>.from(json['viewedBy']),
    );
  }
}
