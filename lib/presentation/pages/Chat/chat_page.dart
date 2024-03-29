import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/chat_message.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/presentation/pages/ChatDetails/chat_details.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/services/sound_recorder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../apis/chat_apis.dart';
import '../../../utilities/my_date_util.dart';
import '../../resources/constants/sizedbox_constants.dart';
import '../Profile/profile_page.dart';
import 'widgets/message_card.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatPage extends StatefulWidget {
  final ChatUser user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool _isUploading = false;
  ChatMessageType _replyType = ChatMessageType.text;
  String _replyText = '';
  var focusNode = FocusNode();
  ChatMessage? message;

  void setReply(ChatMessageType type, String message) {
    print(type);
    print(message);
    setState(() {
      _replyType = type;
      _replyText = message;
    });
    // FocusScope.of(context).requestFocus(focusNode);
  }

  List<ChatMessage> messages = [];
  final _messageController = TextEditingController();

  Widget setReplyWidget(ChatMessageType type, String text) {
    // print(type);
    // print(text);
    switch (type) {
      case ChatMessageType.text:
        return Expanded(
          child: Text(text),
        );
      case ChatMessageType.image:
        return Image(
          image: NetworkImage(text),
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        );
      case ChatMessageType.audio:
        return Expanded(
          child: Row(
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
          ),
        );
      default:
        return Expanded(child: Text(text));
    }
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    _stream = ChatApis.getAllMessages(widget.user);
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
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioPlayer;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const SizedBox(),
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          messages = snapshot.data!.docs
                              .map((e) => ChatMessage.fromJson(e.data()))
                              .toList();
                        }
                        if (messages.isEmpty) {
                          return const Center(
                            child: Text('Say Hii! 🙌'),
                          );
                        } else {
                          return SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              children: messages
                                  .map(
                                    (e) =>
                                        ChangeNotifierProvider<AudioProvider>(
                                      create: (context) => AudioProvider(),
                                      child: MessageCard(
                                        chatMessage: e,
                                        setReplyText: setReply,
                                        userName: widget.user.userName,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              if (_isUploading)
                const Padding(
                  padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
              if (_replyText.isNotEmpty)
                Column(
                  children: [
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          setReplyWidget(
                            _replyType,
                            _replyText,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _replyText = '';
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              // ZegoSendCallInvitationButton(

              //   isVideoCall: true,
              //   resourceID: "zegouikit_call", // For offline call notification
              //   invitees: [
              //     ZegoUIKitUser(
              //       id: widget.user.userId,
              //       name: widget.user.email,
              //     ),
              //     // ...ZegoUIKitUser(
              //     //   id: targetUserID,
              //     //   name: targetUserName,
              //     // ),
              //   ],
              // ),
              Consumer<AudioProvider>(builder: (context, soundData, child) {
                if (soundData.isRecording) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Recording...',
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
              Consumer<AudioProvider>(builder: (context, soundData, child) {
                if (soundData.isUploading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
              _chatInput(),
            ],
          ),
        ),
      ),
    );
  }

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
                  setState(
                    () => _isUploading = true,
                  );

                  await ChatApis.sendChatImage(
                    widget.user,
                    _replyText,
                    File(image.path),
                    _replyType,
                  );
                  setState(
                    () => _isUploading = false,
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
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintText: 'Message...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          // voice button
          GestureDetector(
            onLongPress: () async {
              await Provider.of<AudioProvider>(context, listen: false)
                  .recordVoice();
            },
            onLongPressEnd: (_) async {
              await Provider.of<AudioProvider>(
                context,
                listen: false,
              ).stopRecording(
                widget.user,
                _replyType,
              );
            },
            child: const Icon(
              Icons.keyboard_voice_outlined,
            ),
          ),

          // multiple image picker
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();

              // Picking multiple images
              final List<XFile> images =
                  await picker.pickMultiImage(imageQuality: 70);

              // uploading & sending image one by one
              for (var i in images) {
                log('Image Path: ${i.path}');
                setState(() => _isUploading = true);
                await ChatApis.sendChatImage(
                  widget.user,
                  _replyText,
                  File(i.path),
                  _replyType,
                );
                setState(() => _isUploading = false);
              }
            },
            icon: const Icon(
              Icons.image_outlined,
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
                      _replyText,
                      ChatMessageType.text,
                      _replyType,
                    );
                    _messageController.clear();
                    setState(() {
                      _replyText = '';
                    });
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

  Widget _appBar() {
    return StreamBuilder(
      stream: ChatApis.getUserInfo(widget.user.userId),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        chatUser: widget.user,
                        navigateBack: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .3),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.height * 0.055,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.profileImage,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBoxConstants.sizedboxw10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ChatDetails.routename,
                          arguments: widget.user,
                        );
                      },
                      child: Text(
                        widget.user.userName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive,
                                )
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive,
                            ),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 13,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.phone,
                ),
              ),
              StreamBuilder(
                  stream: ChatApis.getLastMessage(
                    widget.user,
                  ),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;

                    final list = data
                            ?.map((e) => ChatMessage.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (list.isNotEmpty) {
                      message = list[0];
                    }

                    return IconButton(
                      onPressed: () async {
                        // await ChatApis.sendVideoRequestMessage(
                        //   widget.user,
                        //   '',
                        //   '',
                        //   ChatMessageType.videoChat,
                        //   VideoChat(
                        //     id: DateTime.now()
                        //         .millisecondsSinceEpoch
                        //         .toString(),
                        //     duration: '10',
                        //     message: 'started a video call.',
                        //   ),
                        //   true,
                        // ).then((value) {
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) => CallScreen(
                        //         callerId: ChatApis.getConversationId(
                        //             widget.user.userId),
                        //         userName: 'userName',
                        //         chatUser: widget.user,
                        //       ),
                        //     ),
                        //   );
                        // });
                      },
                      icon: Icon(
                        Icons.videocam,
                        color: message != null && message!.isVideoCallOn
                            ? Colors.blueAccent
                            : null,
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}
