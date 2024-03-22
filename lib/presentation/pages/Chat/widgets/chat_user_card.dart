import 'package:cached_network_image/cached_network_image.dart';
import 'package:instaclone/models/chat_message.dart';
import 'package:instaclone/presentation/pages/Chat/chat_page.dart';
import 'package:instaclone/services/sound_recorder.dart';
import 'package:instaclone/utilities/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../apis/chat_apis.dart';
import '../../../../models/chat_user.dart';
import '../../../resources/constants/sizedbox_constants.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser chatUser;
  const ChatUserCard({
    super.key,
    required this.chatUser,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  ChatMessage? message;

  Widget messageContent(ChatMessageType chatMessageType) {
    switch (chatMessageType) {
      case ChatMessageType.text:
        return Text(
          message != null
              ? ChatApis.user?.uid == message!.fromId
                  ? 'You: ${message!.message}'
                  : message!.message
              : 'Wave 🙌',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      case ChatMessageType.image:
        return Text(
          message != null
              ? ChatApis.user!.uid == message!.fromId
                  ? 'You sent an image.'
                  : '${widget.chatUser.userName} sent an image.'
              : 'Wave 🙌',
          style: Theme.of(context).textTheme.bodyMedium,
        );

      case ChatMessageType.videoChat:
        return Text(
          message != null
              ? ChatApis.user!.uid == message!.fromId
                  ? 'You started a call.'
                  : '${widget.chatUser.userName} started a call.'
              : 'Wave 🙌',
          style: Theme.of(context).textTheme.bodyMedium,
        );

      case ChatMessageType.audio:
        return Text(
          ChatApis.user!.uid == message!.fromId
              ? 'You sent a voice message.'
              : '${widget.chatUser.userName} sent a voice message.',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<AudioProvider>(
                create: (context) => AudioProvider(),
                child: ChatPage(user: widget.chatUser)),
          ),
        );
      },
      child: StreamBuilder(
        stream: ChatApis.getLastMessage(widget.chatUser),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          final list =
              data?.map((e) => ChatMessage.fromJson(e.data())).toList() ?? [];
          if (list.isNotEmpty) {
            message = list[0];
          }

          return ListTile(
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .3),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.height * 0.055,
                    fit: BoxFit.cover,
                    imageUrl: widget.chatUser.profileImage,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                  ),
                ),
                if (widget.chatUser.isOnline)
                  const Positioned(
                    bottom: -1,
                    right: -1,
                    child: Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 15,
                    ),
                  ),
              ],
            ),
            title: Text(
              widget.chatUser.userName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: messageContent(
                    message?.type ?? ChatMessageType.text,
                  ),
                ),
                SizedBoxConstants.sizedboxw5,
                Flexible(
                  child: Text(
                    message != null
                        ? MyDateUtil.getLastMessageTime(
                            context: context, time: message!.sent)
                        : '',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
