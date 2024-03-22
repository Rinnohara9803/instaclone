// import 'dart:convert';
// import 'dart:math';
// import 'package:instaclone/services/shared_service.dart';
// import 'package:http/http.dart' as http;

// class EmailService {
//   static Future<void> sendEmail({
//     required String name,
//     required String email,
//   }) async {
//     try {
//       final random = Random();

//       int next(int min, int max) => min + random.nextInt(max - min);
//       int otp = next(100000, 999999);
//       const serviceId = 'service_6yhkqag';
//       const templateId = 'template_de9y3uy';
//       const userId = '4fBfKASEVUpxuj995';
//       final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
//       await http
//           .post(
//         url,
//         headers: {
//           'origin': 'http://localhost',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(
//           {
//             'service_id': serviceId,
//             'template_id': templateId,
//             'user_id': userId,
//             'template_params': {
//               'user_subject': 'Email Verification Code',
//               'to_user': name,
//               'pin_code': otp,
//               'to_email': email,
//               'user_email': 'sagarprajapati9803@gmail.com'
//             },
//           },
//         ),
//       )
//           .then((value) {
//         SharedService.otp = otp.toString();
//       });
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }
// }
