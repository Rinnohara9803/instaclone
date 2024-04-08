import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:instaclone/presentation/pages/ShareProfile/widgets/colored_background.dart';
import 'package:instaclone/presentation/pages/ShareProfile/widgets/imaged_background.dart';
import 'package:instaclone/presentation/pages/ShareProfile/widgets/qr_image.dart';
import 'package:instaclone/presentation/pages/ShareProfile/widgets/share_profile_icon_widget.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/providers/share_profile_provider.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<Uint8List> getQrImage(
      double height,
      double width,
      ShareProfileProvider shareProfileData,
      ProfileProvider profileData) async {
    final screenshotController = ScreenshotController();
    Uint8List image = await screenshotController.captureFromWidget(
      Material(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: height * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: shareProfileData.selectedColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: shareProfileData.currentBackgroundState ==
                        QrBackgroundState.color
                    ? null
                    : shareProfileData.selectedImagePath.isEmpty
                        ? null
                        : Image(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(
                                shareProfileData.selectedImagePath,
                              ),
                            ),
                          ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageWidget(
                    height: height,
                    width: width,
                    shareProfileData: shareProfileData,
                    profileData: profileData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return image;
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
            Consumer<ShareProfileProvider>(
                builder: (context, shareProfileData, child) {
              return Consumer<ProfileProvider>(
                  builder: (context, profileData, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageWidget(
                        height: height,
                        width: width,
                        shareProfileData: shareProfileData,
                        profileData: profileData,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ShareProfileIconWidget(
                              icon: Icons.share,
                              title: 'Share profile',
                              onTap: () async {
                                await getQrImage(height, width,
                                        shareProfileData, profileData)
                                    .then(
                                  (Uint8List image) async {
                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    final imagePath =
                                        await File('${directory.path}/qr.png')
                                            .create();
                                    await imagePath.writeAsBytes(image);

                                    await Share.shareXFiles([
                                      XFile(
                                        imagePath.path,
                                      ),
                                    ]);
                                  },
                                );
                              },
                              disabled: false,
                            ),
                            ShareProfileIconWidget(
                              icon: Icons.link,
                              title: 'Copy link',
                              onTap: () {},
                              disabled: true,
                            ),
                            ShareProfileIconWidget(
                              icon: Icons.download,
                              title: 'Download',
                              onTap: () async {
                                getQrImage(height, width, shareProfileData,
                                        profileData)
                                    .then((Uint8List image) async {
                                  final directory =
                                      await getApplicationDocumentsDirectory();
                                  final imagePath =
                                      await File('${directory.path}/qr.png')
                                          .create();
                                  await imagePath.writeAsBytes(image);

                                  await GallerySaver.saveImage(
                                    imagePath.path,
                                    albumName: 'Instaclone',
                                  ).then((value) {
                                    Toasts.showNormalSnackbar(
                                        context, 'Image downloaded.');
                                  }).catchError((e) {
                                    Toasts.showErrorSnackBar(
                                      context,
                                      'Something went wrong.',
                                    );
                                  });

                                  /// Share Plugin
                                  // await Share.shareFiles([imagePath.path]);
                                });
                              },
                              disabled: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
            }),
          ],
        ),
      ),
    );
  }
}
