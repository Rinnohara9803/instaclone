import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/share_profile_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageWidget extends StatelessWidget {
  const QrImageWidget({
    super.key,
    required this.height,
    required this.width,
    required this.profileData,
    required this.shareProfileData,
  });

  final double height;
  final double width;
  final ProfileProvider profileData;
  final ShareProfileProvider shareProfileData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: height * 0.05,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              QrImageView(
                data: profileData.chatUser.userId.substring(0, 11),
                version: QrVersions.min,
                size: width * 0.55,
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: shareProfileData.selectedColors,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: QrImageView(
                  data: profileData.chatUser.userId.substring(0, 11),
                  version: QrVersions.auto,
                  size: width * 0.55,
                ),
              ),
            ],
          ),
          SizedBoxConstants.sizedboxh10,
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: shareProfileData.selectedColors,
              ).createShader(bounds);
            },
            child: Text(
              '@${profileData.chatUser.userName}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
