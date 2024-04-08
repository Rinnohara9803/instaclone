import 'package:instaclone/presentation/pages/Register/register_with_phone_page_one.dart';
import 'package:instaclone/presentation/resources/colors_manager.dart';
import 'package:instaclone/presentation/resources/constants/gradients_constants.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/services/auth_service.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../Login/widgets/animed_hollow_button.dart';
import '../Verify-Email/verify_email_page.dart';

class RegisterWithEmailPageOne extends StatefulWidget {
  static const routename = '/register';
  const RegisterWithEmailPageOne({super.key});

  @override
  State<RegisterWithEmailPageOne> createState() =>
      _RegisterWithEmailPageOneState();
}

class _RegisterWithEmailPageOneState extends State<RegisterWithEmailPageOne> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isButtonLongPressed = false;

  void switchIsButtonLongPressed() {
    setState(() {
      _isButtonLongPressed = !_isButtonLongPressed;
    });
  }

  bool _isSignUpButtonLongPressed = false;

  void switchIsSignUpButtonLongPressed() {
    setState(() {
      _isSignUpButtonLongPressed = !_isSignUpButtonLongPressed;
    });
  }

  bool hasError = false;
  bool isVisible = true;
  bool _isLoading = false;

  Future<void> signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        hasError = true;
      });
      return;
    }

    setState(() {
      hasError = false;
    });
    try {
      setState(() {
        _isLoading = true;
      });

      await AuthService.signUpWithEmail(
              _emailController.text, _passwordController.text)
          .then((value) {
        Navigator.of(context).pushNamed(VerifyEmailPage.routename);
      });
    } catch (e) {
      Toasts.showErrorSnackBar(context, e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void clearEmailController() {
    _emailController.clear();
  }

  void clearPasswordController() {
    _passwordController.clear();
  }

  void navigateToRegisterWithPhone() {
    Navigator.of(context).pushNamed(RegisterWithPhonePageOne.routename);
  }

  @override
  void initState() {
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: GradientsConstants.linearGradient0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    child: Text(
                      'What\'s your email?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBoxConstants.sizedboxh5,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    child: Text(
                      'Enter the email where you can be contracted. No one will see this on your profile.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        color: ColorsManager.white,
                      ),
                      cursorColor: Colors.white,
                      autofocus: true,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        bool isEmailValid =
                            EmailValidator.validate(_emailController.text);
                        if (value!.isEmpty) {
                          return 'Enter your email address.';
                        } else if (!isEmailValid) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        label: const Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        suffixIcon: _emailController.text.isEmpty
                            ? null
                            : hasError
                                ? const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      clearEmailController();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: ColorsManager.white,
                                    ),
                                  ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          hasError = false;
                        });
                      },
                      onSaved: (text) {
                        _emailController.text = text!;
                      },
                    ),
                  ),
                  SizedBoxConstants.sizedboxh10,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        color: ColorsManager.white,
                      ),
                      cursorColor: Colors.white,
                      autofocus: false,
                      obscureText: isVisible,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your email address.';
                        } else if (value.length <= 6) {
                          return 'Password must be at least 7 characters.';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                          filled: true,
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? Icon(
                                    Icons.visibility,
                                    color: ColorsManager.white,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: ColorsManager.white,
                                  ),
                          )),
                      onChanged: (value) {
                        setState(() {
                          hasError = false;
                        });
                      },
                      onSaved: (text) {
                        _passwordController.text = text!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        await signUpWithEmail();
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
                          child: _isLoading
                              ? const CircularProgressIndicatorWhite()
                              : Text(
                                  'Next',
                                  style: TextStyle(
                                    color: ColorsManager.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AnimatedHollowButton(
                      onTap: navigateToRegisterWithPhone,
                      label: 'Sign up with mobile number',
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Already have an account?',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgressIndicatorWhite extends StatelessWidget {
  const CircularProgressIndicatorWhite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(),
    );
  }
}
