import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  // sign up user with email and password
  static Future<void> signUpWithEmail(String email, String password) async {
    final auth = FirebaseAuth.instance;

    try {
      var userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      var time = DateTime.now().millisecondsSinceEpoch.toString();

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'email': email,
        'createdAt': time,
        'isOnline': false,
        'profileImage': null,
        'lastActive': null,
        'pushToken': null,
        'userName': null,
        'gender': null,
        'bio': null,
      });
    } on FirebaseException catch (e) {
      return Future.error(e.toString());
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // sign in user with email and password
  static Future<void> signInWithEmail(String email, String password) async {
    final auth = FirebaseAuth.instance;

    try {
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        // ZegoUIKitPrebuiltCallInvitationService().init(
        //   appID: 2064517723 /*input your AppID*/,
        //   appSign:
        //       '6435425b31f12e800b4933a69a457a8209748a8a8c28da8972200ec05ac1db42' /*input your AppSign*/,
        //   userID: ChatApis.user!.uid,
        //   userName: ChatApis.user!.email.toString(),
        //   plugins: [ZegoUIKitSignalingPlugin()],
        // );
      });
    } on FirebaseException catch (e) {
      return Future.error(e.toString());
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // logout user
  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      ChatApis.updateActiveStatus(false);
      // ZegoUIKitPrebuiltCallInvitationService().uninit();
    });
  }
}
