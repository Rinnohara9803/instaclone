import 'package:flutter/material.dart';

import '../models/user_post.dart';

class PostDetailsPopDialogProvider with ChangeNotifier {
  bool _showDialog = false;

  bool get showDialog {
    return _showDialog;
  }

  String? _userId;

  String? get userId {
    return _userId;
  }

  UserPostModel? _selectedPost;
  UserPostModel? get selectedPost {
    return _selectedPost;
  }

  void setSelectedPost(UserPostModel userPostModel) {
    _selectedPost = userPostModel;
    notifyListeners();
    _userId = _selectedPost!.userId;
    notifyListeners();
  }

  void setShowDialog() {
    _showDialog = !_showDialog;
    notifyListeners();
  }

  GlobalKey favoriteIconButtonKey = GlobalKey();
  GlobalKey commentIconButtonKey = GlobalKey();
  GlobalKey sendIconButtonKey = GlobalKey();
  GlobalKey menuIconButtonKey = GlobalKey();

  Offset favoriteIconButtonKeyPosition = const Offset(0, 0);
  Offset commentIconButtonKeyPosition = const Offset(0, 0);
  Offset sendIconButtonKeyPosition = const Offset(0, 0);
  Offset menuIconButtonKeyPosition = const Offset(0, 0);

  bool isCommentButtonGestured = false;
  bool isFavoriteButtonGestured = false;
  bool isSendButtonGestured = false;
  bool isMenuButtonGestured = false;

  void setGesturedTofalse() {
    isCommentButtonGestured = false;
    notifyListeners();
    isFavoriteButtonGestured = false;
    notifyListeners();
    isSendButtonGestured = false;
    notifyListeners();
    isMenuButtonGestured = false;
    notifyListeners();
  }

  void setIsCommentButtonGestured(bool value) {
    isCommentButtonGestured = value;
    notifyListeners();
    isFavoriteButtonGestured = false;
    notifyListeners();
    isSendButtonGestured = false;
    notifyListeners();
    isMenuButtonGestured = false;
    notifyListeners();
  }

  void setIsFavoriteButtonGestured(bool value) {
    isFavoriteButtonGestured = value;
    notifyListeners();
    isCommentButtonGestured = false;
    notifyListeners();
    isSendButtonGestured = false;
    notifyListeners();
    isMenuButtonGestured = false;
    notifyListeners();
  }

  void setIsSendButtonGestured(bool value) {
    isSendButtonGestured = value;
    notifyListeners();
    isCommentButtonGestured = false;
    notifyListeners();
    isFavoriteButtonGestured = false;
    notifyListeners();
    isMenuButtonGestured = false;
    notifyListeners();
  }

  void setIsMenuButtonGestured(bool value) {
    isMenuButtonGestured = value;
    notifyListeners();
    isCommentButtonGestured = false;
    notifyListeners();
    isFavoriteButtonGestured = false;
    notifyListeners();
    isSendButtonGestured = false;
    notifyListeners();
  }

  void accessButtonPositions() {
    RenderBox commentbox =
        commentIconButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset commentPosition = commentbox.localToGlobal(Offset.zero);
    commentIconButtonKeyPosition = commentPosition;
    notifyListeners();

    RenderBox favoritebox =
        favoriteIconButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset favoritePosition = favoritebox.localToGlobal(Offset.zero);
    favoriteIconButtonKeyPosition = favoritePosition;
    notifyListeners();

    RenderBox sendBox =
        sendIconButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset sendPosition = sendBox.localToGlobal(Offset.zero);
    sendIconButtonKeyPosition = sendPosition;
    notifyListeners();

    RenderBox menuBox =
        menuIconButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset menuPosition = menuBox.localToGlobal(Offset.zero);
    menuIconButtonKeyPosition = menuPosition;
    notifyListeners();
  }
}
