import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/utilities/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';

import '../../../../apis/chat_apis.dart';
import '../../../../models/chat_message.dart';
import '../../../resources/constants/sizedbox_constants.dart';

class MessageCard extends StatefulWidget {
  final ChatMessage chatMessage;

  final Function(ChatMessageType, String) setReplyText;
  final String userName;
  const MessageCard({
    super.key,
    required this.chatMessage,
    required this.setReplyText,
    required this.userName,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Widget blueMessageContent(
      String message, VideoChat videoChat, ChatMessageType messageType) {
    switch (messageType) {
      case ChatMessageType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Text(message),
        );
      case ChatMessageType.image:
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(
              15,
            ),
            topRight: Radius.circular(
              15,
            ),
            bottomLeft: Radius.circular(
              15,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: message,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.image,
              size: 70,
            ),
          ),
        );
      case ChatMessageType.videoChat:
        return const Text('You started a video chat');
      case ChatMessageType.audio:
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                if (!isAudioPlaying) {
                  await audioPlayer.play(
                    UrlSource(widget.chatMessage.message),
                  );
                } else {
                  await audioPlayer.stop();
                }
              },
              icon: isAudioPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(
                      Icons.play_arrow,
                    ),
            ),
            Expanded(
              child: Slider(
                min: 0,
                activeColor: Colors.redAccent,
                inactiveColor: Colors.grey,
                thumbColor: Colors.white,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {},
              ),
            ),
          ],
        );
      default:
        return Text(message);
    }
  }

  Widget setReplyWidget(ChatMessageType type, String text) {
    // print(type);
    // print(text);
    switch (type) {
      case ChatMessageType.text:
        return Expanded(child: Text(text));
      case ChatMessageType.image:
        return Image(
          image: NetworkImage(text),
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        );
      case ChatMessageType.audio:
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                if (!isAudioPlaying) {
                  await audioPlayer.play(
                    UrlSource(text),
                  );
                } else {
                  await audioPlayer.stop();
                }
              },
              icon: isAudioPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(
                      Icons.play_arrow,
                    ),
            ),
            Expanded(
              child: Slider(
                min: 0,
                activeColor: Colors.redAccent,
                inactiveColor: Colors.grey,
                thumbColor: Colors.white,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {},
              ),
            ),
          ],
        );
      default:
        return Expanded(child: Text(text));
    }
  }

  Widget greyMessageContent(
      String message, VideoChat videoChat, ChatMessageType messageType) {
    switch (messageType) {
      case ChatMessageType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Text(message),
        );
      case ChatMessageType.image:
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(
              15,
            ),
            topRight: Radius.circular(
              15,
            ),
            bottomRight: Radius.circular(
              15,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: message,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.image,
              size: 70,
            ),
          ),
        );
      case ChatMessageType.videoChat:
        return Text('${widget.userName} started a video chat');
      case ChatMessageType.audio:
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                if (!isAudioPlaying) {
                  await audioPlayer.play(
                    UrlSource(widget.chatMessage.message),
                  );
                } else {
                  await audioPlayer.stop();
                }
              },
              icon: isAudioPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(
                      Icons.play_arrow,
                    ),
            ),
            Expanded(
              child: Slider(
                min: 0,
                activeColor: Colors.red,
                inactiveColor: Colors.grey,
                thumbColor: Colors.white,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {},
              ),
            ),
          ],
        );
      default:
        return Text(message);
    }
  }

  // grey message => chat-users's message
  Widget greyMessage() {
    if (widget.chatMessage.read.isEmpty) {
      ChatApis.updateReadStatus(widget.chatMessage);
    }
    return Column(
      children: [
        if (widget.chatMessage.replyText.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  '${widget.userName} replied',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalDivider(
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black
                          : Colors.white,
                      thickness: 2,
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: widget.chatMessage.replyType ==
                                  ChatMessageType.text
                              ? 10
                              : 0,
                          horizontal: widget.chatMessage.replyType ==
                                  ChatMessageType.text
                              ? 20
                              : 0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black26
                                  : const Color.fromARGB(255, 39, 38, 38),
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: setReplyWidget(
                          widget.chatMessage.replyType,
                          widget.chatMessage.replyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FocusedMenuHolder(
                  blurSize: 0.2,
                  onPressed: () {},
                  duration: const Duration(
                    seconds: 0,
                  ),
                  animateMenuItems: false,
                  menuWidth: 200,
                  blurBackgroundColor: Colors.black.withOpacity(
                    0.01,
                  ),
                  openWithTap: false,
                  menuItems: [
                    FocusedMenuItem(
                      trailingIcon: Icon(
                        Icons.reply,
                        color: Provider.of<ThemeProvider>(context).isLightTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                      backgroundColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.black12
                              : const Color.fromARGB(255, 51, 48, 48),
                      title: Text(
                        'Reply',
                        style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        widget.setReplyText(
                          widget.chatMessage.type,
                          widget.chatMessage.message,
                        );
                      },
                    ),
                    if (widget.chatMessage.type == ChatMessageType.text)
                      FocusedMenuItem(
                        trailingIcon: Icon(
                          Icons.copy,
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        backgroundColor:
                            Provider.of<ThemeProvider>(context).isLightTheme
                                ? Colors.black12
                                : const Color.fromARGB(255, 51, 48, 48),
                        title: Text(
                          'Copy',
                          style: TextStyle(
                            color:
                                Provider.of<ThemeProvider>(context).isLightTheme
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: widget.chatMessage.message,
                            ),
                          );
                        },
                      ),
                  ],
                  child: Container(
                    // padding: const EdgeInsets.all(
                    //   8,
                    // ),
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Colors.grey,
                      // ),
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black12
                          : Colors.black,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          30,
                        ),
                        topRight: Radius.circular(
                          30,
                        ),
                        bottomRight: Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: greyMessageContent(
                      widget.chatMessage.message,
                      widget.chatMessage.videoChat,
                      widget.chatMessage.type,
                    ),
                  ),
                ),
              ),
              SizedBoxConstants.sizedboxw10,
              Text(
                MyDateUtil.getFormattedTime(
                  context: context,
                  time: widget.chatMessage.sent,
                ),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // blue message => users's message
  Widget blueMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.chatMessage.replyText.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  'You replied',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: widget.chatMessage.replyType ==
                                  ChatMessageType.text
                              ? 10
                              : 0,
                          horizontal: widget.chatMessage.replyType ==
                                  ChatMessageType.text
                              ? 20
                              : 0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black26
                                  : const Color.fromARGB(255, 39, 38, 38),
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: setReplyWidget(
                          widget.chatMessage.replyType,
                          widget.chatMessage.replyText,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black
                          : Colors.white,
                      thickness: 2,
                    )
                  ],
                ),
              ),
            ],
          ),
        Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
            top: widget.chatMessage.replyText.isEmpty ? 10 : 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (widget.chatMessage.read.isNotEmpty)
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.lightBlue
                          : Colors.blue,
                    ),
                  if (widget.chatMessage.read.isNotEmpty)
                    SizedBoxConstants.sizedboxw5,
                  Text(
                    MyDateUtil.getFormattedTime(
                      context: context,
                      time: widget.chatMessage.sent,
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBoxConstants.sizedboxw10,
              Flexible(
                child: FocusedMenuHolder(
                  blurSize: 0.2,
                  onPressed: () {},
                  duration: const Duration(
                    seconds: 0,
                  ),
                  animateMenuItems: false,
                  menuWidth: 200,
                  blurBackgroundColor: Colors.black.withOpacity(
                    0.01,
                  ),
                  openWithTap: false,
                  menuItems: [
                    FocusedMenuItem(
                      trailingIcon: Icon(
                        Icons.reply,
                        color: Provider.of<ThemeProvider>(context).isLightTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                      backgroundColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.black12
                              : const Color.fromARGB(255, 51, 48, 48),
                      title: Text(
                        'Reply',
                        style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        widget.setReplyText(widget.chatMessage.type,
                            widget.chatMessage.message);
                      },
                    ),
                    if (widget.chatMessage.type == ChatMessageType.text)
                      FocusedMenuItem(
                        trailingIcon: Icon(
                          Icons.copy,
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        backgroundColor:
                            Provider.of<ThemeProvider>(context).isLightTheme
                                ? Colors.black12
                                : const Color.fromARGB(255, 51, 48, 48),
                        title: Text(
                          'Copy',
                          style: TextStyle(
                            color:
                                Provider.of<ThemeProvider>(context).isLightTheme
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: widget.chatMessage.message,
                            ),
                          );
                        },
                      ),
                    FocusedMenuItem(
                      trailingIcon: const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.red,
                      ),
                      backgroundColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.black12
                              : const Color.fromARGB(255, 51, 48, 48),
                      title: Text(
                        'Unsend',
                        style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await ChatApis.deleteChatMessage(widget.chatMessage);
                      },
                    ),
                  ],
                  child: Container(
                    decoration: const BoxDecoration(
                      // border: Border.all(
                      //   color: Colors.grey,
                      // ),
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          30,
                        ),
                        topRight: Radius.circular(
                          30,
                        ),
                        bottomLeft: Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: blueMessageContent(
                      widget.chatMessage.message,
                      widget.chatMessage.videoChat,
                      widget.chatMessage.type,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // widget.getIsVideoCallOnValue(widget.chatMessage.isVideoCallOn);
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isAudioPlaying = state == PlayerState.playing;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioPlayer;
    // widget.getIsVideoCallOnValue(widget.chatMessage.isVideoCallOn);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.getIsVideoCallOnValue(widget.chatMessage.isVideoCallOn);
    return widget.chatMessage.fromId == ChatApis.user!.uid
        ? blueMessage()
        : greyMessage();
  }
}
