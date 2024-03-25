import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class AddStoryWidget extends StatelessWidget {
  const AddStoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, userData, _) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        margin: const EdgeInsets.only(
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.085,
                    width: MediaQuery.of(context).size.height * 0.085,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.amber,
                          Colors.red,
                        ],
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.040,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * .2),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.077,
                            width: MediaQuery.of(context).size.height * 0.077,
                            fit: BoxFit.cover,
                            imageUrl: userData.chatUser.profileImage.isEmpty
                                ? 'no image'
                                : userData.chatUser.profileImage,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: -4,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue,
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBoxConstants.sizedboxh5,
            Text(
              'Your story',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }
}
