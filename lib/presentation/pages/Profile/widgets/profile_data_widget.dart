import 'package:flutter/material.dart';

class ProfileDataWidget extends StatelessWidget {
  final int data;
  final String label;
  final Function onTap;
  const ProfileDataWidget({
    super.key,
    required this.data,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            Text(data.toString()),
            Text(label),
          ],
        ),
      ),
    );
  }
}
