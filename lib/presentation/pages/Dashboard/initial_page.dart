import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/presentation/pages/AddMedia/add_media_page.dart';
import 'package:instaclone/presentation/pages/Chat/chats_page.dart';
import 'package:instaclone/presentation/pages/Dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:provider/provider.dart';

import '../../../apis/chat_apis.dart';

class InitialPage extends StatefulWidget {
  static const String routename = '/initial-page';
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  void navigateToChatsPage() {
    _tabController!.animateTo(2);
  }

  void navigateBackToHomePage() {
    _tabController!.animateTo(1);
  }

  void navigateToPostPage() {
    _tabController!.animateTo(0);
  }

  // pages for tab-bar-view
  List<Widget>? pages;

  @override
  void initState() {
    pages = [
      // open-camera page
      AddPostOrReelsOrStoryPage(
        navigateBack: navigateBackToHomePage,
      ),
      // dashboard page
      DashboardPage(
        navigateToChatsPage: navigateToChatsPage,
        navigateToPostPage: navigateToPostPage,
        navigateBackToHomePage: navigateBackToHomePage,
      ),

      // chats page
      ChatsPage(
        navigateBack: navigateBackToHomePage,
      ),
    ];
    // update the users online status
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
    super.initState();
    _tabController = TabController(
      length: pages!.length,
      vsync: this,
      initialIndex: 1,
    );
    _tabController!.addListener(() {
      print(_tabController!.index);
      if (_tabController!.index == 1) {
        print('resetting provider');
        Provider.of<FetchMediasProvider>(context, listen: false)
            .clearSelectedMedias();
        Provider.of<FetchMediasProvider>(context, listen: false)
            .toggleToSelectOneMedia();
        Provider.of<FetchMediasProvider>(context, listen: false)
            .disposeController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: pages!.length,
      child: TabBarView(
        controller: _tabController,
        children: pages!,
      ),
    );
  }
}
