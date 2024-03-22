class ChatUser {
  ChatUser({
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.profileImage,
    required this.userName,
    required this.pushToken,
    required this.userId,
    required this.email,
  });
  late final String createdAt;
  late final String lastActive;
  late final bool isOnline;
  late final String profileImage;
  late final String userName;
  late final String pushToken;
  late final String userId;
  late final String email;

  ChatUser.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? '';
    lastActive = json['lastActive'] ?? '';
    isOnline = json['isOnline'];
    profileImage = json['profileImage'] ?? '';
    userName = json['userName'] ?? '';
    pushToken = json['pushToken'] ?? '';
    userId = json['userId'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['lastActive'] = lastActive;
    data['isOnline'] = isOnline;
    data['profileImage'] = profileImage;
    data['userName'] = userName;
    data['pushToken'] = pushToken;
    data['userId'] = userId;
    data['email'] = email;
    return data;
  }
}
