import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:instaclone/presentation/pages/Dashboard/dashboard_page.dart';
import 'package:instaclone/presentation/pages/Dashboard/initial_page.dart';
import 'package:instaclone/presentation/pages/Login/widgets/forget_password_button.dart';
import 'package:instaclone/presentation/pages/Register/register_with_email_page.dart';
import 'package:instaclone/presentation/pages/Verify-Email/verify_email_page.dart';
import 'package:instaclone/presentation/resources/constants/gradients_constants.dart';
import 'package:instaclone/services/auth_service.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/assets_manager.dart';
import 'package:instaclone/presentation/resources/colors_manager.dart';
import 'package:provider/provider.dart';
import '../../../providers/profile_provider.dart';
import '../../resources/constants/sizedbox_constants.dart';
import '../../widgets/general_textformfield.dart';
import 'widgets/animed_hollow_button.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isButtonLongPressed = false;

  void switchIsButtonLongPressed() {
    setState(() {
      _isButtonLongPressed = !_isButtonLongPressed;
    });
  }

  void navigateToRegisterPage() {
    Navigator.of(context).pushNamed(RegisterWithEmailPageOne.routename);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return SafeArea(
          child: Scaffold(
        body: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            // linear gradient on container
            gradient: GradientsConstants.linearGradient0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  height: 50,
                  width: 50,
                  image: AssetImage(
                    AssetsManager.distagramLogo,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GeneralTextFormField(
                  hasPrefixIcon: true,
                  hasSuffixIcon: false,
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.endsWith('.com')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.mail_outline,
                  autoFocus: false,
                ),

                SizedBoxConstants.sizedboxh10,
                GeneralTextFormField(
                  hasPrefixIcon: true,
                  hasSuffixIcon: true,
                  controller: _passwordController,
                  label: 'Password',
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter your password.';
                    } else if (value.trim().length < 6) {
                      return 'Please enter at least 6 characters.';
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  iconData: Icons.lock,
                  autoFocus: false,
                ),
                SizedBoxConstants.sizedboxh10,
                // login button
                GestureDetector(
                  onTap: () async {
                    await AuthService.signInWithEmail(
                            _emailController.text, _passwordController.text)
                        .then((value) async {
                      bool isEmailVerified =
                          FirebaseAuth.instance.currentUser!.emailVerified;
                      if (isEmailVerified) {
                        await Provider.of<ProfileProvider>(context,
                                listen: false)
                            .fetchProfile()
                            .then((value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              InitialPage.routename, (route) => false);
                        });
                      } else {
                        Navigator.of(context)
                            .pushNamed(VerifyEmailPage.routename);
                      }
                    }).catchError((e) {
                      Toasts.showErrorSnackBar(context, e.toString());
                    });
                  },
                  onLongPress: () {
                    switchIsButtonLongPressed();
                  },
                  onLongPressEnd: (_) {
                    switchIsButtonLongPressed();
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.symmetric(
                        horizontal: _isButtonLongPressed ? 10 : 0),
                    height: 51,
                    width: double.infinity,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 71, 229)
                          .withOpacity(_isButtonLongPressed ? 0.5 : 1),
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: ColorsManager.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const ForgotPasswordButton(),
                if (!isKeyboardVisible)
                  const SizedBox(
                    height: 50,
                  ),
                if (!isKeyboardVisible)
                  AnimatedHollowButton(
                      onTap: navigateToRegisterPage,
                      label: 'Create new account'),
                if (!isKeyboardVisible) SizedBoxConstants.sizedboxh20,
                if (!isKeyboardVisible)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.catching_pokemon,
                        color: ColorsManager.white,
                        size: 20,
                      ),
                      Text(
                        'RINO9803',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                          color: ColorsManager.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ));
    });
  }
}
