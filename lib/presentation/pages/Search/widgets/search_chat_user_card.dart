import 'package:cached_network_image/cached_network_image.dart';
import 'package:instaclone/presentation/pages/Profile/profile_page.dart';
import 'package:flutter/material.dart';

import '../../../../models/chat_user.dart';

class SearchChatUserCard extends StatefulWidget {
  final ChatUser chatUser;
  const SearchChatUserCard({
    super.key,
    required this.chatUser,
  });

  @override
  State<SearchChatUserCard> createState() => _SearchChatUserCardState();
}

class _SearchChatUserCardState extends State<SearchChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              chatUser: widget.chatUser,
              navigateBack: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
      child: ListTile(
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
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.person,
                  ),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.person,
                  ),
                ),
              ),
            ),
            // if (widget.chatUser.isOnline)
            //   const Positioned(
            //     bottom: -1,
            //     right: -1,
            //     child: Icon(
            //       Icons.circle,
            //       color: Colors.green,
            //       size: 15,
            //     ),
            //   ),
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
              child: Text(
                widget.chatUser.email,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
