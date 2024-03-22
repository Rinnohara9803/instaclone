import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                      'assets/avatar.png'), // Replace with your avatar image
                ),
                SizedBox(width: 8),
                Text(
                  'Username', // Replace with the username
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Image.network(
              'https://lh3.googleusercontent.com/E1zNMJhGw6QHx4ogVyEl1Gc0W1EKZAxguOuc4cVje4Yu2L2q8BrBPpUW2w23g3wwufwKFueMlIxOv1utVhGrQ4MDbYaBhRtZU3repPAZ2MalGID9cte-zke_U6wEydMWF0qY1NBhaIRMc5EmcNfWpF4', // Replace with your image
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.favorite),
                Icon(Icons.comment),
                Icon(Icons.share),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
