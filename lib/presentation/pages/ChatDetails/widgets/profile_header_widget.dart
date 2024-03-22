import 'package:flutter/material.dart';

import '../../../resources/constants/sizedbox_constants.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  const ProfileHeaderWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 23,
          ),
          SizedBoxConstants.sizedboxh10,
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
