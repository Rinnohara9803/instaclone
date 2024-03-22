enum StoryType {
  image,
  video,
}

class Story {
  final String id; // Unique identifier for the story
  final String username;
  final String mediaUrl; // URL of the image or video
  final StoryType type;
  final Duration duration; // Duration of the story

  Story({
    required this.id,
    required this.username,
    required this.mediaUrl,
    required this.type,
    required this.duration,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      username: json['username'] as String,
      mediaUrl: json['mediaUrl'] as String,
      type: json['type'] == 'image' ? StoryType.image : StoryType.video,
      duration: Duration(milliseconds: json['duration'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'mediaUrl': mediaUrl,
      'type': type == StoryType.image ? 'image' : 'video',
      'duration': duration.inMilliseconds,
    };
  }
}
