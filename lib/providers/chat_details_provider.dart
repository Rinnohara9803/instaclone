import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/models/chat_user.dart';

class ChatDetailsProvider with ChangeNotifier {
  List<String> _chatImages = [];

  List<String> get chatImages {
    return [..._chatImages];
  }

  Future<void> fetchChatImages(ChatUser user, bool refresh) async {
    if (_chatImages.isEmpty || refresh == true) {
      try {
        final List<String> imageUrls = [];

        final ListResult result = await FirebaseStorage.instance
            .ref('images/${ChatApis.getConversationId(user.userId)}')
            .list();
        for (final Reference ref in result.items.reversed) {
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }

        _chatImages = imageUrls;
        notifyListeners();
      } catch (e) {
        return Future.error(e.toString());
      }
    }
  }
}
