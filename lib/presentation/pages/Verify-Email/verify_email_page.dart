import 'dart:async';
import 'package:instaclone/presentation/pages/Chat/chats_page.dart';
import 'package:instaclone/presentation/pages/Dashboard/dashboard_page.dart';
import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/Login/login_page.dart';
import 'package:instaclone/presentation/pages/Register/register_with_email_page.dart';
import 'package:instaclone/presentation/resources/assets_manager.dart';
import 'package:instaclone/presentation/resources/colors_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/profile_provider.dart';
import '../../resources/constants/sizedbox_constants.dart';

class VerifyEmailPage extends StatefulWidget {
  static String routename = '/verify-email-page';
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? _timer;

  void navigateToChatsPage() {
    Navigator.of(context).pushNamed(ChatsPage.routename);
  }

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        await Provider.of<ProfileProvider>(context, listen: false)
            .fetchProfile()
            .then((value) {
          checkEmailVerified();
        });
      });
    } else {
      Navigator.of(context).pushReplacementNamed(InitialPage.routename);
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  // check if the email is verified or not
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      _timer!.cancel();
    }
  }

  // send verification email
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification().then((value) {});
    } catch (e) {
      Navigator.of(context).pushNamed(RegisterWithEmailPageOne.routename);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const InitialPage()
      : SafeArea(
          child: Scaffold(
            body: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorsManager.lightBlue,
                          ColorsManager.lightRed,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        AssetsManager.distagramLogo,
                        height: 115,
                        width: 115,
                      ),
                    ),
                  ),
                  SizedBoxConstants.sizedboxh20,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Text(
                      'Verification link has been sent to your email address.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account ? ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                            LoginPage.routename,
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBoxConstants.sizedboxh20,
                ],
              ),
            ),
          ),
        );
}
