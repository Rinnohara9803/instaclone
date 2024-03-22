import 'package:instaclone/presentation/pages/Chat/chats_page.dart';
import 'package:instaclone/presentation/pages/Dashboard/camera_page.dart';
import 'package:instaclone/presentation/pages/Dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    print('back');
    _tabController!.animateTo(1);
  }

  // pages for tab-bar-view
  List<Widget>? pages;

  @override
  void initState() {
    pages = [
      // open-camera page
      CameraPage(
        navigateBack: navigateBackToHomePage,
      ),
      // dashboard page
      DashboardPage(
        navigateToChatsPage: navigateToChatsPage,
      ),

      // chats page
      ChatsPage(
        navigateBack: navigateBackToHomePage,
      ),
    ];
    // update the users online status
    ChatApis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (ChatApis.auth.currentUser != null) {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          initialIndex: 1,
          length: pages!.length,
          child: Scaffold(
            body: TabBarView(
              controller: _tabController,
              children: pages!,
            ),
          ),
        ),
      ),
    );
  }
}
