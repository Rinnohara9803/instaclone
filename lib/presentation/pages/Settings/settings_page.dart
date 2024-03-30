import 'package:firebase_core/firebase_core.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/presentation/pages/Login/login_page.dart';
import 'package:instaclone/presentation/pages/Register/register_with_email_page.dart';
import 'package:instaclone/presentation/pages/Settings/dark_mode_page.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/services/auth_service.dart';

class SettingsWidgetModel {
  final String label;
  final IconData iconData;
  final Function onTap;

  SettingsWidgetModel(
      {required this.label, required this.iconData, required this.onTap});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<SettingsWidgetModel> _settingsWidgetModels;

  @override
  void initState() {
    _settingsWidgetModels = [
      SettingsWidgetModel(
        label: 'Follow and invite friends',
        iconData: Icons.person_add_outlined,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DarkModePage(),
            ),
          );
        },
      ),
      SettingsWidgetModel(
        label: 'Dark mode',
        iconData: Icons.dark_mode_outlined,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DarkModePage(),
            ),
          );
        },
      ),
      SettingsWidgetModel(
        label: 'Log Out',
        iconData: Icons.logout,
        onTap: () async {
          await AuthService.logOut().then((value) {
            ChatApis.updateActiveStatus(false);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
          });
        },
      ),
    ];
    super.initState();
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
            'Settings',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          children: [
            ..._settingsWidgetModels.map(
              (swm) => InkWell(
                onTap: () {
                  swm.onTap();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        swm.iconData,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        swm.label,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
