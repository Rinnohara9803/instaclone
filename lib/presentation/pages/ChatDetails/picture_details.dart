import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/models/chat_message.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';

import '../../resources/constants/sizedbox_constants.dart';

class PictureDetails extends StatefulWidget {
  final String imageUrl;
  final ChatUser user;
  const PictureDetails({Key? key, required this.imageUrl, required this.user})
      : super(key: key);

  @override
  State<PictureDetails> createState() => _PictureDetailsState();
}

class _PictureDetailsState extends State<PictureDetails> {
  Future<void> _downloadImage(BuildContext context) async {
    try {
      final response = await Dio().get(widget.imageUrl,
          options: Options(responseType: ResponseType.bytes));

      final directory = await getApplicationDocumentsDirectory();
      print(directory);
      final file = File('${directory.path}/image.jpg');
      await file.writeAsBytes(response.data);

      SnackBars.showNormalSnackbar(
        context,
        'Image downloaded successfully.',
      );
    } catch (e) {
      SnackBars.showErrorSnackBar(context, 'Failed to download image.');
    }
  }

  final _messageController = TextEditingController();
  var focusNode = FocusNode();

  Widget _chatInput() {
    return Container(
      margin: const EdgeInsets.all(
        8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Provider.of<ThemeProvider>(context).isLightTheme
            ? Colors.black12
            : const Color.fromARGB(255, 37, 32, 32),
        borderRadius: BorderRadius.circular(
          33,
        ),
      ),
      child: Row(
        children: [
          // open camera
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();

                // Pick an image
                final XFile? image = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 70);
                if (image != null) {
                  log('Image Path: ${image.path}');

                  await ChatApis.sendChatImage(
                    widget.user,
                    widget.imageUrl,
                    File(image.path),
                    ChatMessageType.image,
                  );
                }
              },
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
              ),
            ),
          ),
          SizedBoxConstants.sizedboxw5,

          // text field to send message
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintText: 'Reply...',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),

          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Center(
              child: IconButton(
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    ChatApis.sendMessage(
                      widget.user,
                      _messageController.text.trim(),
                      widget.imageUrl,
                      ChatMessageType.text,
                      ChatMessageType.image,
                    );
                    _messageController.clear();
                  } else {
                    return;
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _downloadImage(context);
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context).isLightTheme
                      ? Colors.white
                      : Colors.black),
              imageProvider: NetworkImage(widget.imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.0,
              initialScale: PhotoViewComputedScale.contained,
              loadingBuilder: (context, event) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error),
                );
              },
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }
}
