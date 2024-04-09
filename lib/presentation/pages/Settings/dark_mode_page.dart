import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({super.key});

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  void toggleDarkMode() {
    Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).toggleThemes();
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
            'Dark Mode',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Consumer<ThemeProvider>(builder: (context, themeData, _) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('On'),
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        checkColor: Theme.of(context).primaryColor,
                        value: !themeData.isLightTheme,
                        onChanged: (bool? value) {
                          toggleDarkMode();
                        },
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Off'),
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        checkColor: Theme.of(context).primaryColor,
                        value: themeData.isLightTheme,
                        onChanged: (bool? value) {
                          toggleDarkMode();
                        },
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
