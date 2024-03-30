import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/presentation/pages/EditProfile/select_profile_picture_page.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  void showBottomSheet(BuildContext context, List<CameraDescription> camers) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.17,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Provider.of<ThemeProvider>(context).isLightTheme
                          ? Colors.black45
                          : Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelectProfilePicturePage(
                            cameras: cameras,
                          )));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.photo_camera,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'New profile picture',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Remove current picture',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  late List<CameraDescription> cameras;

  @override
  void initState() {
    getCameras();
    super.initState();
  }

  void getCameras() async {
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        body: Consumer<ProfileProvider>(builder: (context, profileData, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .2),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.085,
                      width: MediaQuery.of(context).size.height * 0.085,
                      fit: BoxFit.cover,
                      imageUrl: profileData.chatUser.profileImage.isEmpty
                          ? 'no image'
                          : profileData.chatUser.profileImage,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.height * 0.055,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showBottomSheet(context, cameras);
                    },
                    child: Text(
                      'Edit picture',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.blueAccent,
                          ),
                    ),
                  ),
                  EditProfileItem(
                    title: 'Name',
                    value: profileData.chatUser.userName,
                    onTap: () {},
                  ),
                  EditProfileItem(
                    title: 'Bio',
                    value: profileData.chatUser.bio,
                    onTap: () {},
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(profileData.chatUser.gender),
                            const Icon(
                              Icons.arrow_circle_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class EditProfileItem extends StatelessWidget {
  final String title;
  final String value;
  final Function onTap;
  const EditProfileItem({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }
}
