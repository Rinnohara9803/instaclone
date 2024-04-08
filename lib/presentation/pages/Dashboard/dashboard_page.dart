import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instaclone/presentation/pages/Profile/profile_page.dart';
import 'package:instaclone/presentation/pages/Profile/widgets/user_post_grid_view_widget.dart';
import 'package:instaclone/presentation/pages/UserReels/latest_reels_page.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:instaclone/providers/post_details_popop_provider.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../apis/chat_apis.dart';
import '../Home/home_page.dart';
import '../Search/search_page.dart';

class DashboardPage extends StatefulWidget {
  final Function navigateToChatsPage;
  final Function navigateToPostPage;
  final Function navigateBackToHomePage;
  static const String routename = '/dashboard-page';
  const DashboardPage({
    super.key,
    required this.navigateToChatsPage,
    required this.navigateToPostPage,
    required this.navigateBackToHomePage,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _pageController = PageController(
    initialPage: 0,
  );

  int _selectedIndex = 0;

  // returns currently running page-view to home page
  void _returnToHomePage() {
    setState(() {
      _selectedIndex = 0;
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  // navigate to select image page
  void _onItemTapped(int index) async {
    if (index == 2) {
      // get read-external-storage permission
      var permission = await Permission.storage.request();
      if (permission == PermissionStatus.granted) {
        // ignore: use_build_context_synchronously
        widget.navigateToPostPage();
      } else {
        throw 'Photos access denied.';
      }
    } else {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(_selectedIndex);
      });
    }
  }

  @override
  void initState() {
    print("dashboard page init");
    super.initState();
    ChatApis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (message.toString().contains('resume')) {
          ChatApis.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          ChatApis.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('dashboard building');
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // page view of 5 pages namely: home,search,add-post,reels and profile
            Expanded(
              child: PageView(
                scrollBehavior: null,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  // home page
                  HomePage(
                    navigateToChatsPage: widget.navigateToChatsPage,
                  ),

                  // search-users page
                  SearchPage(
                    returnToHomePage: _returnToHomePage,
                  ),

                  // add post page - dummy
                  const SizedBox(),

                  // reels page
                  const LatestReelsPage(),
                  // profile page
                  ProfilePage(
                    chatUser: Provider.of<ProfileProvider>(context).chatUser,
                    navigateBack: _returnToHomePage,
                  ),
                ],
              ),
            ),
          ],
        ),

        // primary bottom-nav-bar for dashboard
        bottomNavigationBar: Stack(
          children: [
            SizedBox(
              height: 70,
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 0
                        ? const Icon(Icons.home)
                        : const Icon(Icons.home_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 1
                        ? const Icon(Icons.search_rounded)
                        : const Icon(Icons.search_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 2
                        ? const Icon(Icons.add_box)
                        : const Icon(Icons.add_box_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 3
                        ? const Icon(Icons.movie_creation_rounded)
                        : const Icon(Icons.movie_creation_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: _selectedIndex == 4 ? 2 : 1,
                            color: Theme.of(context).errorColor),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Consumer<ProfileProvider>(
                          builder: (context, profileData, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .2,
                          ),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.025,
                            width: MediaQuery.of(context).size.height * 0.025,
                            fit: BoxFit.cover,
                            imageUrl: profileData.chatUser.profileImage.isEmpty
                                ? 'no image'
                                : profileData.chatUser.profileImage,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Icon(
                              Icons.person,
                              size: MediaQuery.of(context).size.height * 0.020,
                              color: Colors.grey,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: MediaQuery.of(context).size.height * 0.020,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                    label: '',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                iconSize: 25,
                onTap: _onItemTapped,
                elevation: 10,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Consumer<PostDetailsPopDialogProvider>(
                builder: (ctx, data, child) {
                  if (data.showDialog == false) {
                    return const SizedBox();
                  } else {
                    return Container(
                      height: 70,
                      width: double.infinity,
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black45
                          : Colors.white54,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple,
      ),
    );
  }
}

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
      ),
    );
  }
}
