import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/ChatDetails/chat_details.dart';
import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/Register/register_with_email_page.dart';
import 'package:instaclone/presentation/pages/Register/register_with_phone_page_one.dart';
import 'package:instaclone/presentation/pages/Splash/splash_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/select_image_page.dart';
import 'package:instaclone/presentation/pages/UploadPost/select_video_page.dart';
import 'package:instaclone/presentation/pages/Verify-Email/verify_email_page.dart';
import 'package:instaclone/providers/chat_details_provider.dart';
import 'package:instaclone/providers/profile_data_provider.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:instaclone/providers/user_stories_provider.dart';
import 'package:instaclone/providers/video_provider.dart';
import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'firebase_options.dart';
import 'presentation/pages/Login/login_page.dart';
import 'presentation/resources/themes_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  final navigatorKey = GlobalKey<NavigatorState>();

  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // ZegoUIKit().initLog().then((value) {
  //   ///  Call the `useSystemCallingUI` method
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );

  runApp(MyApp(navigatorKey: navigatorKey));
  // });
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // profile provider
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),

        // followings-followers provider
        ChangeNotifierProvider<ProfileDataProvider>(
          create: (context) => ProfileDataProvider(),
        ),

        // user posts provider
        ChangeNotifierProvider<UserPostsProvider>(
          create: (context) => UserPostsProvider(),
        ),

        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<ChatDetailsProvider>(
          create: (context) => ChatDetailsProvider(),
        ),
        ChangeNotifierProvider<VideoPlayerProvider>(
          create: (context) => VideoPlayerProvider(),
        ),
        ChangeNotifierProvider<UserStoriesProvider>(
          create: (context) => UserStoriesProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeData, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'instaclone',

            // themes manager
            theme: themeData.isLightTheme
                ? getLightApplicationTheme()
                : getDarkApplicationTheme(),
            home: const SplashPage(),

            // named page-routes
            routes: {
              LoginPage.routename: (context) => const LoginPage(),
              RegisterWithEmailPageOne.routename: (context) =>
                  const RegisterWithEmailPageOne(),
              RegisterWithPhonePageOne.routename: (context) =>
                  const RegisterWithPhonePageOne(),
              VerifyEmailPage.routename: (context) => const VerifyEmailPage(),
              InitialPage.routename: (context) => const InitialPage(),
              SelectImagePage.routename: (context) => const SelectImagePage(),
              SelectVideoPage.routename: (context) => const SelectVideoPage(),
              ChatDetails.routename: (context) => const ChatDetails(),
            },
          );
        },
      ),
    );
  }
}
