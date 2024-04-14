import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';

class ShareProfileIconWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool disabled;

  const ShareProfileIconWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await onTap();
        },
        child: Center(
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
                    color: disabled ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              SizedBoxConstants.sizedboxh5,
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: disabled ? Colors.grey : Colors.black,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
