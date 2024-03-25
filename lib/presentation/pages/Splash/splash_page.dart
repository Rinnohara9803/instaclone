import 'dart:io';
import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/Login/login_page.dart';
import 'package:instaclone/presentation/resources/assets_manager.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../providers/profile_provider.dart';
import '../../resources/constants/sizedbox_constants.dart';
import '../Verify-Email/verify_email_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // fetch user-info
  Future fetchUser() async {
    // check auth-state-changes
    // ignore: unrelated_type_equality_checks
    if (FirebaseAuth.instance.authStateChanges().isEmpty == true) {
      print('no data');
      Navigator.pushNamed(context, LoginPage.routename);
    } else {
      print('yes data');
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == false) {
        Navigator.pushNamed(context, VerifyEmailPage.routename);
        return;
      } else {
        try {
          await Provider.of<ProfileProvider>(context, listen: false)
              .fetchProfile()
              .then((value) {
            Navigator.pushReplacementNamed(context, InitialPage.routename);
          });
        } on SocketException catch (e) {
          SnackBars.showErrorSnackBar(context, e.toString());
          Navigator.pushReplacementNamed(context, LoginPage.routename);
        } catch (e) {
          print(e);
          SnackBars.showErrorSnackBar(context, e.toString());
          Navigator.pushReplacementNamed(context, LoginPage.routename);
        }
      }
    }
  }

  @override
  void initState() {
    // ZegoUIKitPrebuiltCallInvitationService().init(
    //   appID: 2064517723 /*input your AppID*/,
    //   appSign:
    //       '6435425b31f12e800b4933a69a457a8209748a8a8c28da8972200ec05ac1db42' /*input your AppSign*/,
    //   userID: ChatApis.user!.uid,
    //   userName: ChatApis.user!.email.toString(),
    //   plugins: [ZegoUIKitSignalingPlugin()],
    // );
    Future.delayed(const Duration(seconds: 0), () {
      fetchUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Provider.of<ThemeProvider>(context).isLightTheme
                ? [
                    Colors.white70,
                    Colors.white,
                  ]
                : [
                    Colors.black87,
                    Colors.black,
                  ],
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  height: 65,
                  width: 65,
                  image: AssetImage(
                    AssetsManager.distagramLogo,
                  ),
                ),
                SizedBoxConstants.sizedboxh10,
                Text(
                  'instaclone',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
