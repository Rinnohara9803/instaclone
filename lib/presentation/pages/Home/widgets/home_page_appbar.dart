import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/Dashboard/widgets/custom_popup_menubutton.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'instaclone',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        ),
        const CustomPopUpMenuButton(),
      ],
    );
  }
}
