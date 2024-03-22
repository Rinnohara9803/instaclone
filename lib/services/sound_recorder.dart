import 'dart:io';
import 'package:instaclone/models/chat_message.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

import '../apis/chat_apis.dart';

class AudioProvider with ChangeNotifier {
  bool _isRecording = false;

  bool _isUploading = false;

  bool get isRecording => _isRecording;
  bool get isUploading => _isUploading;
  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  late String recordFilePath;

  Future<void> recordVoice() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission denied.';
    }
    _isRecording = true;
    notifyListeners();
    recordFilePath = await getFilePath();
    RecordMp3.instance.start(recordFilePath, (type) {});
  }

  Future<void> stopRecording(ChatUser user, ChatMessageType type) async {
    bool stop = RecordMp3.instance.stop();
    if (stop) {
      _isRecording = false;
      notifyListeners();
      _isUploading = true;

      notifyListeners();
      await ChatApis.sendAudioMessage(
        user,
        '',
        File(recordFilePath),
        type,
      ).then((value) {
        _isUploading = false;
        notifyListeners();
      }).catchError((e) {
        _isUploading = false;
        notifyListeners();
      });
    }
  }
}
