class ChatMessage {
  ChatMessage({
    required this.toId,
    required this.read,
    required this.message,
    required this.type,
    required this.fromId,
    required this.sent,
    required this.replyText,
    required this.videoChat,
    required this.isVideoCallOn,
    required this.replyType, // Added field
  });

  late final String toId;
  late final String read;
  late final String message;
  late final ChatMessageType type;
  late final String fromId;
  late final String sent;
  late final String replyText;
  late final VideoChat videoChat;
  late final bool isVideoCallOn;
  late final ChatMessageType replyType; // Added field

  ChatMessage.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    read = json['read'].toString();
    message = json['message'].toString();
    type = json['type'].toString() == ChatMessageType.text.name
        ? ChatMessageType.text
        : json['type'].toString() == ChatMessageType.image.name
            ? ChatMessageType.image
            : json['type'].toString() == ChatMessageType.videoChat.name
                ? ChatMessageType.videoChat
                : ChatMessageType.audio;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
    replyText = json['replyText'].toString();
    videoChat = VideoChat.fromJson(json['videoChat']);
    isVideoCallOn = json['isVideoCallOn'];
    replyType = json['replyType'].toString() == ChatMessageType.text.name
        ? ChatMessageType.text
        : json['replyType'].toString() == ChatMessageType.image.name
            ? ChatMessageType.image
            : json['replyType'].toString() == ChatMessageType.videoChat.name
                ? ChatMessageType.videoChat
                : ChatMessageType.audio;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['read'] = read;
    data['message'] = message;
    data['type'] = type == ChatMessageType.text
        ? 'text'
        : type == ChatMessageType.image
            ? 'image'
            : type == ChatMessageType.videoChat
                ? 'videoChat'
                : 'audio';
    data['fromId'] = fromId;
    data['sent'] = sent;
    data['replyText'] = replyText;
    data['videoChat'] = videoChat.toJson();
    data['isVideoCallOn'] = isVideoCallOn;
    data['replyType'] = replyType == ChatMessageType.text
        ? 'text'
        : replyType == ChatMessageType.image
            ? 'image'
            : replyType == ChatMessageType.videoChat
                ? 'videoChat'
                : 'audio';
    return data;
  }
}

class VideoChat {
  VideoChat({
    required this.id,
    required this.duration,
    required this.message,
  });
  late final String id;
  late final String duration;
  late final String message;

  VideoChat.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    duration = json['duration'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration;
    data['message'] = message;

    return data;
  }
}

enum ChatMessageType { text, image, videoChat, audio }
