// import 'package:instaclone/presentation/pages/Register/register_with_email_page.dart';
// import 'package:instaclone/presentation/resources/colors_manager.dart';
// import 'package:instaclone/presentation/resources/constants/gradients_constants.dart';
// import 'package:instaclone/services/email_service.dart';
// import 'package:instaclone/utilities/snackbars.dart';
// import 'package:flutter/material.dart';
// import '../../../services/shared_service.dart';
// import '../../resources/constants/sizedbox_constants.dart';
// import '../Login/widgets/animated_button.dart';

// class EmailConfirmationPage extends StatefulWidget {
//   static const routename = '/email-confirmation-page';
//   const EmailConfirmationPage({
//     super.key,
//   });

//   @override
//   State<EmailConfirmationPage> createState() => _EmailConfirmationPageState();
// }

// class _EmailConfirmationPageState extends State<EmailConfirmationPage> {
//   final _confirmationCodeController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   bool hasError = false;

//   bool _isLoading = false;

//   bool _isSignUpButtonLongPressed = false;

//   void switchIsSignUpButtonLongPressed() {
//     setState(() {
//       _isSignUpButtonLongPressed = !_isSignUpButtonLongPressed;
//     });
//   }

//   // void validateConfirmationCode() {
//   //   if (!_formKey.currentState!.validate()) {
//   //     setState(() {
//   //       hasError = true;
//   //     });
//   //     return;
//   //   } else if (_confirmationCodeController.text != SharedService.otp) {
//   //     SnackBars.showErrorSnackBar(context, 'Invalid otp.');
//   //     return;
//   //   }
//   //   setState(() {
//   //     hasError = false;
//   //   });
//   // }

//   void clearConfirmationCodeController() {
//     _confirmationCodeController.clear();
//   }

//   late String emailAddress;

//   Future<void> sendVerificationEmail(String email) async {
//     setState(() {
//       _isLoading = true;
//     });
//     await EmailService.sendEmail(name: 'User', email: email).then((value) {
//       SnackBars.showNormalSnackbar(
//           context, 'Verification email has been sent.');
//     }).catchError((e) {
//       SnackBars.showErrorSnackBar(context, 'An error occurred.');
//     });
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     _confirmationCodeController.addListener(() {
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _confirmationCodeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final routeArgs =
//         ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
//     final email = routeArgs['email'] as String;
//     emailAddress = email;
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 18,
//           ),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: GradientsConstants.linearGradient0,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                   ),
//                   child: Text(
//                     'Enter the confirmation code',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//                 SizedBoxConstants.sizedboxh5,
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                   ),
//                   child: Text(
//                     'To confirm your account, enter the 6-digit code we sent to $email',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                   ),
//                   child: TextFormField(
//                     style: TextStyle(
//                       color: ColorsManager.white,
//                     ),
//                     cursorColor: Colors.white,
//                     autofocus: true,
//                     obscureText: false,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter the confirmation code sent to your email address.';
//                       }
//                       return null;
//                     },
//                     controller: _confirmationCodeController,
//                     decoration: InputDecoration(
//                       fillColor: const Color.fromARGB(255, 33, 38, 63),
//                       filled: true,
//                       label: const Text(
//                         'Confirmation Code',
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       suffixIcon: _confirmationCodeController.text.isEmpty
//                           ? null
//                           : hasError
//                               ? const Icon(
//                                   Icons.error,
//                                   color: Colors.red,
//                                 )
//                               : IconButton(
//                                   onPressed: () {
//                                     clearConfirmationCodeController();
//                                   },
//                                   icon: Icon(
//                                     Icons.clear,
//                                     color: ColorsManager.white,
//                                   ),
//                                 ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         hasError = false;
//                       });
//                     },
//                     onSaved: (text) {
//                       _confirmationCodeController.text = text!;
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: AnimatedButton(
//                     label: 'Next',
//                     onTap: validateConfirmationCode,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       sendVerificationEmail(email);
//                     },
//                     onLongPress: () {
//                       switchIsSignUpButtonLongPressed();
//                     },
//                     onLongPressEnd: (_) {
//                       switchIsSignUpButtonLongPressed();
//                     },
//                     child: AnimatedContainer(
//                       margin: EdgeInsets.symmetric(
//                           horizontal: _isSignUpButtonLongPressed ? 10 : 0),
//                       height: 51,
//                       width: double.infinity,
//                       duration: const Duration(milliseconds: 200),
//                       decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border.all(
//                           color: Colors.white60,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(
//                           50,
//                         ),
//                       ),
//                       child: Center(
//                         child: _isLoading
//                             ? const CircularProgressIndicatorWhite()
//                             : const Text(
//                                 'Resend verification code',
//                                 style: TextStyle(
//                                   color: Colors.white60,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Expanded(
//                   child: SizedBox(),
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: TextButton(
//                       onPressed: () {},
//                       child: const Text('Already have an account?')),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
