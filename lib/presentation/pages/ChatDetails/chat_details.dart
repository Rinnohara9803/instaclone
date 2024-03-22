import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/presentation/pages/ChatDetails/widgets/chat_pictures_gridview.dart';
import 'package:instaclone/presentation/pages/ChatDetails/widgets/profile_header_widget.dart';
import 'package:instaclone/presentation/pages/Profile/profile_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';

class ChatDetails extends StatelessWidget {
  static const String routename = '/chat-details';
  const ChatDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final chatUser = ModalRoute.of(context)!.settings.arguments as ChatUser;

    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .3),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.095,
                    width: MediaQuery.of(context).size.height * 0.095,
                    fit: BoxFit.cover,
                    imageUrl: chatUser.profileImage,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 240, 232, 232),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 240, 232, 232),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBoxConstants.sizedboxh10,
                Text(
                  chatUser.userName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                SizedBoxConstants.sizedboxh20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProfileHeaderWidget(
                      icon: Icons.person_2_outlined,
                      title: 'Profile',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                chatUser: chatUser, navigateBack: () {}),
                          ),
                        );
                      },
                    ),
                    ProfileHeaderWidget(
                      icon: Icons.notifications_off_outlined,
                      title: 'Mute',
                      onTap: () {},
                    ),
                    ProfileHeaderWidget(
                      icon: Icons.search,
                      title: 'Search',
                      onTap: () {},
                    ),
                    ProfileHeaderWidget(
                      icon: Icons.menu,
                      title: 'Options',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBoxConstants.sizedboxh20,
                Row(
                  children: [
                    const Icon(
                      Icons.color_lens,
                      color: Colors.brown,
                    ),
                    SizedBoxConstants.sizedboxw10,
                    Column(
                      children: [
                        Text(
                          'Themes',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBoxConstants.sizedboxh5,
                        Text(
                          'Bubbles',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBoxConstants.sizedboxh10,
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 2,
                        indicatorColor:
                            Theme.of(context).tabBarTheme.indicatorColor,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(
                            icon: Icon(
                              Icons.image_search_outlined,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.videocam_sharp,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ChatPicturesGridView(
                              user: chatUser,
                            ),
                            const Center(
                              child: Text(
                                'No reels till date',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
