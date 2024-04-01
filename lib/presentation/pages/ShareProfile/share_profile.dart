import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/ShareProfile/widgets/colored_background.dart';
import 'package:instaclone/presentation/pages/ShareProfile/widgets/imaged_background.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/share_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum QrBackgroundState { color, image }

class ShareProfilePage extends StatefulWidget {
  static const String routeName = '/share-profile';
  const ShareProfilePage({super.key});

  @override
  State<ShareProfilePage> createState() => _ShareProfilePageState();
}

class _ShareProfilePageState extends State<ShareProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<ShareProfileProvider>(
              builder: (ctx, shareProfileData, child) {
                if (shareProfileData.currentBackgroundState ==
                    QrBackgroundState.color) {
                  return ColoredBackground(
                    height: height,
                    width: width,
                  );
                } else {
                  return ImagedBackground(height: height, width: width);
                }
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                    Consumer<ShareProfileProvider>(
                      builder: (ctx, shareProfileData, child) {
                        return GestureDetector(
                          onLongPress: () {
                            _animationController.forward();
                          },
                          onLongPressEnd: (_) {
                            _animationController.reverse();
                          },
                          onLongPressCancel: () {
                            _animationController.reverse();
                          },
                          onTap: () {
                            shareProfileData.toggleBackgroundState();
                          },
                          child: ScaleTransition(
                            scale: _animation as Animation<double>,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 25,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Text(
                                shareProfileData.currentBackgroundState ==
                                        QrBackgroundState.color
                                    ? 'Color'
                                    : 'Image',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.qr_code,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                        Consumer<ShareProfileProvider>(
                            builder: (context, shareProfileData, child) {
                          return Consumer<ProfileProvider>(
                              builder: (context, profileData, child) {
                            return Stack(
                              children: [
                                QrImageView(
                                  data: profileData.chatUser.userId
                                      .substring(0, 11),
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
                                    data: profileData.chatUser.userId
                                        .substring(0, 11),
                                    version: QrVersions.auto,
                                    size: width * 0.55,
                                  ),
                                ),
                              ],
                            );
                          });
                        }),
                        SizedBoxConstants.sizedboxh10,
                        Consumer<ShareProfileProvider>(
                            builder: (context, spd, child) {
                          return ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: spd.selectedColors,
                              ).createShader(bounds);
                            },
                            child: Consumer<ProfileProvider>(
                                builder: (context, profileData, child) {
                              return Text(
                                '@${profileData.chatUser.userName}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBoxConstants.sizedboxh20,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: width * 0.1,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShareProfileIconWidget(
                            icon: Icons.share, title: 'Share profile'),
                        ShareProfileIconWidget(
                            icon: Icons.link, title: 'Copy link'),
                        ShareProfileIconWidget(
                            icon: Icons.download, title: 'Download'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareProfileIconWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  const ShareProfileIconWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(
                  15,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 25,
                  ),
                ),
              ),
              SizedBoxConstants.sizedboxh5,
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
