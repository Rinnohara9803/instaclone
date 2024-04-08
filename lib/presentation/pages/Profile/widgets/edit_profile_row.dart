import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/presentation/pages/ShareProfile/share_profile.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:provider/provider.dart';

class EditProfileRow extends StatelessWidget {
  const EditProfileRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings:
                      const RouteSettings(name: EditProfilePage.routename),
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Provider.of<ThemeProvider>(context).isLightTheme
                      ? Colors.black
                      : Colors.white,
                ),
                color: Provider.of<ThemeProvider>(context).isLightTheme
                    ? Colors.white
                    : const Color.fromARGB(255, 38, 38, 39),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: const Center(
                child: Text('Edit Profile'),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings:
                      const RouteSettings(name: ShareProfilePage.routeName),
                  builder: (context) => const ShareProfilePage(),
                ),
              );
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Provider.of<ThemeProvider>(context).isLightTheme
                      ? Colors.black
                      : Colors.white,
                ),
                color: Provider.of<ThemeProvider>(context).isLightTheme
                    ? Colors.white
                    : const Color.fromARGB(255, 38, 38, 39),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: const Center(
                child: Text('Share Profile'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
