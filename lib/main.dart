import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instaclone/presentation/pages/ChatDetails/chat_details.dart';
import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_bio_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_gender_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_username_page.dart';
import 'package:instaclone/presentation/pages/Register/register_with_email_page.dart';
import 'package:instaclone/presentation/pages/Register/register_with_phone_page_one.dart';
import 'package:instaclone/presentation/pages/ShareProfile/share_profile.dart';
import 'package:instaclone/presentation/pages/Splash/splash_page.dart';
import 'package:instaclone/providers/chat_details_provider.dart';
import 'package:instaclone/providers/fetch_medias_provider.dart';
import 'package:instaclone/providers/profile_data_provider.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/share_profile_provider.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:instaclone/providers/user_reels_provider.dart';
import 'package:instaclone/providers/user_stories_provider.dart';
import 'package:instaclone/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/pages/Login/login_page.dart';
import 'presentation/resources/themes_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<ProfileDataProvider>(
          create: (context) => ProfileDataProvider(),
        ),
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
        ChangeNotifierProvider<ReelsProvider>(
          create: (context) => ReelsProvider(),
        ),
        ChangeNotifierProvider<ShareProfileProvider>(
          create: (ctx) => ShareProfileProvider(),
        ),
        ChangeNotifierProvider<FetchMediasProvider>(
          create: (ctx) => FetchMediasProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeData, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'instaclone',
            theme: themeData.isLightTheme
                ? getLightApplicationTheme()
                : getDarkApplicationTheme(),
            home: const SplashPage(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case LoginPage.routename:
                  return MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  );
                case RegisterWithEmailPageOne.routename:
                  return MaterialPageRoute(
                    builder: (context) => const RegisterWithEmailPageOne(),
                  );
                case RegisterWithPhonePageOne.routename:
                  return MaterialPageRoute(
                    builder: (context) => const RegisterWithPhonePageOne(),
                  );
                case ChatDetails.routename:
                  return MaterialPageRoute(
                    builder: (context) => const ChatDetails(),
                  );
                case InitialPage.routename:
                  return MaterialPageRoute(
                    builder: (context) => const InitialPage(),
                  );
                case EditProfilePage.routename:
                  return MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  );
                case EditUsernamePage.routeName:
                  return MaterialPageRoute(
                    builder: (context) => const EditUsernamePage(),
                  );
                case EditBioPage.routeName:
                  return MaterialPageRoute(
                    builder: (context) => const EditBioPage(),
                  );
                case EditGenderPage.routeName:
                  return MaterialPageRoute(
                    builder: (ctx) => const EditGenderPage(),
                  );
                case ShareProfilePage.routeName:
                  return MaterialPageRoute(
                    builder: (ctx) => const ShareProfilePage(),
                  );
                default:
                  throw Exception('Invalid route: ${settings.name}');
              }
            },
          );
        },
      ),
    );
  }
}
