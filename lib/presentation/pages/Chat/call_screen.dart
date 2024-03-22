// import 'package:instaclone/models/chat_message.dart';
// import 'package:instaclone/models/chat_user.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// import '../../../apis/chat_apis.dart';

// class CallScreen extends StatefulWidget {
//   final ChatUser chatUser;
//   final String callerId;
//   final String userName;
//   const CallScreen({
//     super.key,
//     required this.callerId,
//     required this.userName,
//     required this.chatUser,
//   });

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   final userId = DateTime.now().millisecondsSinceEpoch.toString();

//   Future<void> onHangUp() async {
//     await ChatApis.sendVideoRequestMessage(
//       widget.chatUser,
//       '',
//       '',
//       ChatMessageType.videoChat,
//       VideoChat(
//         id: userId,
//         duration: 'duration',
//         message: 'Video Chat Ended',
//       ),
//       false,
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: 2064517723,
//       appSign:
//           '6435425b31f12e800b4933a69a457a8209748a8a8c28da8972200ec05ac1db42',
//       callID: widget.callerId,
//       userID: userId,
//       userName: widget.userName,
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()..onHangUp,
//     );
//   }
// }
