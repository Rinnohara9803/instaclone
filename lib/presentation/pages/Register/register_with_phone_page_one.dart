import 'package:instaclone/presentation/resources/colors_manager.dart';
import 'package:instaclone/presentation/resources/constants/gradients_constants.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../resources/constants/sizedbox_constants.dart';
import '../Login/widgets/animed_hollow_button.dart';

class RegisterWithPhonePageOne extends StatefulWidget {
  static const routename = '/register-with-phone-page-one';
  const RegisterWithPhonePageOne({super.key});

  @override
  State<RegisterWithPhonePageOne> createState() =>
      _RegisterWithPhonePageOneState();
}

class _RegisterWithPhonePageOneState extends State<RegisterWithPhonePageOne> {
  final _mobileNumberController = TextEditingController();
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
  bool _isLoading = false;

  Future<void> validateMobileNumber() async {
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
      final auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: '+977${_mobileNumberController.text}',
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          SnackBars.showErrorSnackBar(context, e.toString());
        },
        codeSent: (String verification, int? token) {},
        codeAutoRetrievalTimeout: (e) {
          SnackBars.showErrorSnackBar(context, e.toString());
        },
      );
    } catch (e) {
      SnackBars.showErrorSnackBar(context, 'Email verification failed.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void clearEmailController() {
    _mobileNumberController.clear();
  }

  @override
  void initState() {
    _mobileNumberController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(hasError);
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                    'What\'s your mobile number?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBoxConstants.sizedboxh5,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  child: Text(
                    'Enter the mobile number where you can be contracted. No one will see this on your profile.',
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
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your phone number.';
                      }
                      return null;
                    },
                    controller: _mobileNumberController,
                    decoration: InputDecoration(
                      filled: true,
                      label: const Text(
                        'Mobile number',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      suffixIcon: _mobileNumberController.text.isEmpty
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
                      _mobileNumberController.text = text!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () async {
                      await validateMobileNumber();
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
                    onTap: () {},
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
