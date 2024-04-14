import 'package:flutter/material.dart';

import '../../../../models/user_post.dart';

class AnimatedFavoriteWidget extends StatelessWidget {
  const AnimatedFavoriteWidget({
    super.key,
    required AnimationController animationController1,
    required Animation<double> animation1,
    required this.post,
  })  : _animationController1 = animationController1,
        _animation1 = animation1;

  final AnimationController _animationController1;
  final Animation<double> _animation1;
  final UserPostModel post;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController1,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation1.value,
            child: Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
