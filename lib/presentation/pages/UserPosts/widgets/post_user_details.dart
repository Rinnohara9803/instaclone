import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/models/chat_user.dart';

class PostUserDetails extends StatelessWidget {
  const PostUserDetails({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatApis.getUserInfoWithUserId(userId),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              // image avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .2),
                child: CachedNetworkImage(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.height * 0.045,
                  fit: BoxFit.cover,
                  imageUrl: list.isEmpty ? 'no image' : list[0].profileImage,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),

              // username
              Text(
                list.isEmpty ? '' : list[0].userName,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReelUserDetails extends StatelessWidget {
  const ReelUserDetails({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatApis.getUserInfoWithUserId(userId),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // image avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .2),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.height * 0.045,
                      fit: BoxFit.cover,
                      imageUrl:
                          list.isEmpty ? 'no image' : list[0].profileImage,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  // username
                  Text(
                    list.isEmpty ? '' : list[0].userName,
                  ),
                ],
              ),
              const Icon(
                Icons.more_vert,
              ),
            ],
          ),
        );
      },
    );
  }
}
