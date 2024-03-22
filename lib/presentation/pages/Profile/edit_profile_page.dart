import 'package:instaclone/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.check,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        body: Consumer<ProfileProvider>(builder: (context, profileData, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    profileData.chatUser.profileImage,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Edit picture',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
